## Task 1

### Prerequisites

1. This playbook assumes that you're using it agains remote Ubuntu based instance.

2. Before running this playbook adjust your inventory in `ansible/inventory/hosts`

3. To run this playbook do:

```
cd ansible
ansible-playbook -i inventory-hosts playbook.yaml
```


### Additional thoughts

Due to time constraints several possible improvements were not integrated:

1. Using dynamic inventory if the target is running in a public cloud provider supporting such solution
2. docker-compose should not build the image, it should rather be delivered to some kind of image registry and downloaded 
3. the containers should not run as root user
4. In general, using docker-compose in production is ill-advised
