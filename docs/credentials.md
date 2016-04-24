# Credentials  
Follow these steps to configure your environment for use with these playbooks.  
1. Copy [group_vars/all/credentials.yml.example](../ansible/group_vars/all/credentials.yml.example) to `group_vars/all/credentials.yml`  
2. Open `group_vars/all/credentials.yml` and uncomment the lines required for your playbooks.  

## AWS Playbooks  

|Variable      | Description |
|--------------|-------------|
|aws_access_key|AWS Access Key|
|aws_secret_key|AWS Secret Key|
|aws_keypair   |Key pair to use for EC2 Instances (not including `.pem`|
|aws_owner     |Tags owner with this value on aws resources|

## Other  
Well right now there are no other playbooks, that will change.  
These creds will also be edited the same way.