# Build MSR Lean, Universal Messaging Realm Server and Universal Messaging Template Application Container Images

## Prerequisites

Create the necessary product images first, using the [installation images builder project](https://github.com/Myhael76/sag-az-pipelines-installation-images-builder)
## Required Secure Files

- `sa.share.secrets.sh` - a sourcing shell script file following the structure of `./support/sa.share.secrets` in the prerequisite [installation images builder project](https://github.com/Myhael76/sag-az-pipelines-installation-images-builder)
- `msr-license.xml` - a valid license for Microservices Runtime, as installer requires it
- `um-license.xml` - a valid license for Universal Messaging Realm Server, as installer requires it
