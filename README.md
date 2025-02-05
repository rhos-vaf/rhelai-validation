# rhelai-validation

Once the RHEL AI deployment is complete, do the following:

1. Copy RHEL AI SSH Key
```
oc cp openstack/openstackclient:rhel-ai.pem ~/.ssh/rhel-ai.pem
chmod 600 ~/.ssh/rhel-ai.pem
```

2. Test the SSH Key
```
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/.ssh/rhel-ai.pem cloud-user@192.168.122.222
```

3. Clone the repository
```
git clone https://gitlab.cee.redhat.com/lmartins/rhelai-validation.git
cd rhelai-validation/rhelai-validation
```

4. Run it (requires ansible-core==2.14)
```
ansible-playbook -i inventory main.yaml --extra-vars @vars.yaml
```

