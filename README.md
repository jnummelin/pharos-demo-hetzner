# Pharos @ Hetzner demo

This repo provides simple version how to run [Kontena Pharos](https://www.kontena.io/pharos/) on [Hetzner cloud](https://www.hetzner.com/cloud).

## Preparation

### Hetzner

Naturally you'll need access to Hetzner cloud.

You'll also need:
- API token
- SSH Key

In this example, I've added my default public key on Hetzner side.


## Steps

Setting up Kubernetes using Pharos is super simple.

### Setup tooling

Pharos cli tooling setup is pretty simple, just follow [these instructions](https://www.pharos.sh/docs/getting-started.html#setup-kontena-pharos-cli-toolchain).

The short version is here:
```sh
$ curl -s https://get.pharos.sh | bash
```

```sh
$ chpharos login
Log in using your Kontena Account credentials
Visit https://account.kontena.io/ to register a new account.
Username: adam
Password:
Logged in.
```

```sh
$ chpharos install latest --use
```

The above steps will install the Pro version, if you only want to use the pure OSS version, you can install it using:
```
$ chpharos install latest+oss --use
```


### Configure Terraform variables

There's an `terraform.tfvars.example` file in the repo. Copy that to `terraform.tfvars` and populate with your credentials and other needed bits such as SSH key name.


### Bootstrap Pharos

To bootstrap Pharos with Terraform, simply run `pharos tf apply` in the root of this repo. Pharos CLI tool will first run Terraform and uses the output to initiate the cluster.

In few minutes you should have everything up-and-running.