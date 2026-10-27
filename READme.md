na_oracle_clone_lifecycle
=========

This Ansible-based toolkit automates the setup, cloning, and refreshing of cloned Oracle databases on schedule using the NetApp SnapCenter command line utilities for streamlined lifecycle management. The toolkit applies to Oracle databases deployed to ONTAP storage either on-premises or public cloud and managed by the NetApp SnapCenter UI tool. 

For detailed instructions for running the playbook refer to NetAppDocs: https://docs.netapp.com/us-en/netapp-solutions/databases/automation_ora_clone_lifecycle.html.

License
-------

By accessing, downloading, installing or using the content in this repository, you agree with the terms of the License laid out in [License](license.txt) file.

Note that there are certain restrictions around producing and/or sharing any derivative works with the content in this repository. Please make sure you read the terms of the [License](license.txt) before using the content. If you do not agree to all of the terms, do not access, download, or use the content in this repository.

Requirements
------------

    Ansible controller:
      Ansible version: 2.10 and above
      Python 3
      Python libraries:
        netapp-lib
        xmltodict
        jmespath

    SnapCenter server:
      version 5.0
      backup policy configured
      Source database protected with a backup policy

    Oracle servers:
      Source server managed by SnapCenter
      Target server managed by SnapCenter
      Target server with identical Oracle software stack as source server installed and configured

Ansible target hosts file configuration
---------------------------------------

The toolkit includes a hosts file which define the targets that an Ansible playbook running against. Usually, it is the target Oracle clone hosts. Following is an example file. A host entry includes target host IP address as well as ssh key for an admin user access to the host to execute clone refresh command.

    
    #Oracle clone hosts

    [clone_1]
    ora_04.cie.netapp.com ansible_host=10.61.180.29 ansible_ssh_private_key_file=ora_04.pem

    [clone_2]

    [clone_3]

    
   
Global variables configuration
------------------------------

The Ansible playbooks are variables driven. Below is an example global variable file vars.yml.
    
    # ONTAP specific config variables

    # SnapCtr specific config variables
    snapctr_usr: xxxxxxxx
    snapctr_pwd: 'xxxxxxxx'
    backup_policy: 'Oracle Full offline Backup'

    # Linux specific config variables

    # Oracle specific config variables


Host variables configuration
----------------------------
    
Host variables are defined in host_vars directory named as {{ host_name }}.yml. Below is an example of target Oracle host variable file ora_04.cie.netapp.com.yml that shows typical configuration.

    
    # User configurable Oracle clone db host specific parameters

    # Source database to clone from
    source_db_sid: NTAP1
    source_db_host: ora_03.cie.netapp.com

    # Clone database
    clone_db_sid: NTAP1DEV

    snapctr_obj_id: '{{ source_db_host }}\{{ source_db_sid }}'

Additional clone target Oracle server configuration
---------------------------------------------------

Clone target Oracle server should have the same Oracle software stack as source Oracle server installed and patched. Oracle user .bash_profile has $ORACLE_BASE, and $ORACLE_HOME configured. Also, $ORACLE_HOME variable should match with source Oracle server setting.  Following is an example.

    # .bash_profile
    
    # Get the aliases and functions
    if [ -f ~/.bashrc ]; then
       . ~/.bashrc
    fi

    # User specific environment and startup programs
    export ORACLE_BASE=/u01/app/oracle
    export ORACLE_HOME=/u01/app/oracle/product/19.0.0/NTAP3

Playbook execution
------------------

There are total of three playbooks to execute Oracle database clone lifecycle with SnapCenter CLI utilities.

    1. Install Ansible controller prerequisites - one time only.

       ansible-playbook -i hosts ansible_requirements.yml

    2. Setup clone specification file - one time only.

       ansible-playbook -i hosts clone_1_setup.yml -u admin -e @vars/vars.yml

    3. Create and refresh clone database regularly from crontab with a shell script to call a refresh playbook.
    
       0 */4 * * * /home/admin/na_oracle_clone_lifecycle/clone_1_refresh.sh


For an additional clone database, create a separate clone_n_setup.yml and clone_n_refresh.yml, and clone_n_refresh.sh. Configure the Ansible target hosts and hostname.yml file in host_vars directory accordingly.

Where to find additional information
------------------------------------

To learn more about the NetApp solution automation, review the following website: https://docs.netapp.com/us-en/netapp-solutions/automation/automation_introduction.html


