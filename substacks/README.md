# Nested stacks

This template can be used to logically seperate and deploy distributed services by splitting them into different stacks, while deploying all of this through one "masterstack".

## Prerequisites

* You should be able to use simple heat templates, like shown in the [first steps tutorial](https://docs.syseleven.de/syseleven-stack/en/tutorials/firststeps).
* You know the basics of using the [OpenStack CLI-Tools](https://docs.syseleven.de/syseleven-stack/en/howtos/openstack-cli).
* Environment variables are set, like shown in the [API-Access-Tutorial](https://docs.syseleven.de/syseleven-stack/en/tutorials/api-access).

## How to start this setup

* Download this template. e.g.: `git clone https://github.com/syseleven/heat-examples.git`
* `$ cd /heatteampltes-examples/substacks/`
* Start the setup:

```shell
openstack stack create -t masterstack.yaml <stack_name>
```

## Check stacks

As a quick test we can list our stacks:

```bash
$ syselevenstack@kickstart:~$ openstack stack list
+--------------------------------------+------------------------------------+-----------------+---------------------+--------------+
| ID                                   | Stack Name                         | Stack Status    | Creation Time       | Updated Time |
+--------------------------------------+------------------------------------+-----------------+---------------------+--------------+
| 55026072-1efe-404e-930a-8d7f862968b2 | masterstack-substack3-p2nqg4hqqovd | CREATE_COMPLETE | 2017-10-11T15:08:45 | None         |
| 2ab31e2a-0836-469f-ac4d-650b349d811e | masterstack-substack2-36koanelqe65 | CREATE_COMPLETE | 2017-10-11T15:08:43 | None         |
| 3cd38935-455c-408d-982f-db03329625e5 | masterstack-substack1-7hz3thzcw4sl | CREATE_COMPLETE | 2017-10-11T15:08:40 | None         |
| 6dc0a945-ecef-4ca0-913b-7c9c21936779 | masterstack                        | CREATE_COMPLETE | 2017-10-11T15:08:39 | None         |
+--------------------------------------+------------------------------------+-----------------+---------------------+--------------+
```

* The nested stacks are linked to the masterstack. When deleting the parent stack (masterstack) the nested stacks will be automatically removed as well.
* Updating the whole stack through the master stack works fine, but it is also possible to just update nested stacks without interacting with the parent stack. This is a huge advantage e.g. when having to rebuild only one nested stack without affecting other stacks.

