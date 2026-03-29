```
# run this command on azure terminal (bash) to generate json of AZURE_CREDENTIALS

        only provide subscriptions id after subscriptions/
        -------------------------------------------------
        
        az ad sp create-for-rbac \
        --name "springboot-github-actions-sp" \
        --role Contributor \
        --scopes /subscriptions/dde8a869-f29f-41ae-90ea-0047779211e6 \
        --sdk-auth
```