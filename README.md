# Dependencies
Ensure that you have the following tools installed on your machine:

- [Task](https://taskfile.dev/installation/)
- [MiniKube](https://minikube.sigs.k8s.io/docs/start/)
- [docker](https://docs.docker.com/engine/install/)

# Authentication

Authenticate and create Github Personal Access Token [ghcr.io](https://github.com/twlabs/data-mesh-deployment-environment-images#local-development) to pull deployment enviornment 
and set docker image pull secret

# Local Development

If you are using [colima](https://github.com/abiosoft/colima) as a container runtime, please start it with the following command. Otherwise ensure your docker daemon is running.

```
colima start --cpu 4 --memory 10
```

Set your Github Personal Access token as an enviornment variable to create docker image pull secret in k8s cluster:
```
export GHCR_ACCESS_TOKEN=<your github access token>
```

Deploy fybrik to minikube with the following command. This may take awhile:
```
ENVIRONMENT=local task deploy-fybrik
```

All pods created during local execution of `test-fybrik` task will use the `ghcr.io/twlabs/test-fybrik:latest` image, and the test image used in eks environment will use the tag set by `DOCKER_TEST_IMAGE_TAG` environment variable. This is to be able test changes to the `test-fybrik` image locally without affecting testing that occurs in eks.

New images are built, pushed, and tagged by the `build-and-push` workflow which is triggered with a git tag. Images are tagged using semver versioning.

# data-mesh-federated-computational-governance-plane


potential issue:
    - make opa policy manager look at specific namespaces for policies
        - could lead to policy collisions??
    - in the open metadata deployment, we should create a service user with creds and use those 
        service user creds in fybrik deployment

refactor ideas:
    - update fybrik blueprints ns for vault and fybrik manager
    - delete openmetadata assets in cleanup

    - create github service user and use those creds to create github token used for image pull secrets
        instead of omars personal one
    - try doing docker login as part of taskfile and not action to make local more seamless
    - decouple vault and fybrik
        - this can allow us to use vault as cred store
            - for example openmeatadata admin creds for dev and prod

https://github.com/fybrik/fybrik/discussions/2104


helm upgrade --install vault fybrik-charts/vault -n fybrik-system-dev \
    --set "vault.injector.enabled=false" \
    --set "vault.server.dev.enabled=true" \
    --set "vault.server.extraEnvironmentVars.OM_SERVER_URL=http://openmetadata.open-metadata-dev:8585/api" \
    --values ./tmp/tmp.yaml