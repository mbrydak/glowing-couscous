## Task 2

> How would you structure your Terraform project if you have multiple environments
and use different cloud providers?

Structuring Terraform projects is not an easy tasks, due to Terraform design (more on that further).

First - given the requirement of multiple environments, there are several strategies for managing it.

1. Create a separate folder for each env.
2. Create a separate branch for each env.
3. Leverage Terraform workspace for each env.

While 1 and 2 have been widely used to this day, I've got some issues with both (let's talk more about it on Tuesday though), but tl;dr: 

Option 1 is off the table due to redundancy of code that's being produced - it's much harder to keep al the envs in sync when you have to make each change at least 3 times (dev, preprod, prod), it's easier to makes mistakes and in general it's no fun.

Option 2 is off the table because feature branching in general is evil (just ask Thierry de Pauw https://www.youtube.com/watch?v=cHgDdRW3WO0), it's even messier to keep in check and while it isn't that big of an issue in terms of CI/CD - following the KISS philosophy I'd rather go with trunk for my git flow.

In this case the best option would be to use terraform workspaces, which allow you to replicate your infrastructure between envs without any issues: either using ternary operators with `terraform.workspace` or load variables/locals based on the workspace you're currently using: (https://xebia.com/blog/how-to-use-terraform-workspaces-to-manage-environment-based-configuration-2/). From my experience working with previous customers it is really reliable, easy to develop and maintain, in general the DX is spot on.

Taking care of that, let's get back to the general structure of your project. (here comes the terraform design issue part), keeping all your terraform code for particular project in a single folder is not the best idea in the world (since you have to apply the whole module at once - hence - everything in the directory you're at when you're running terraform plan/apply) - because then you have to: 1. wait really long for terraform to do it's thing - which is not ideal for both productivity (you're just wasting time during at your screen), and can significantly slow down both the development time and the ever important (especially in DevOps) feedback loop cycle. 2. In general you want your changes to be as atomic as possible, and running terraform against your whole infra is the opposite of that.

And on the off-chance that something goes wrong during this long terraform run (the longer it runs and more infra components are controlled/requested over the api) the bigger the risk of your state being corrupted in the worst case or being forced to sit through yet another extremely long apply.

To wrap it up - there are several ways of structuring the terraform code in terms of the code-base structure, most sensible would be to either group them by their lifecycle (frequent changing things are in a one folder less-frequent things in another) or by dependencies (keeping your albs close to your ec2s, to decomission them alongside the compute to avoid creeping costs). For more structured body of knowledge there is a great article by Lee Briggs (https://leebriggs.co.uk/blog/2023/08/17/structuring-iac), even though it's about Pulumi it stil translates great to Terraform world.

In terms of mutli-cloud approach - to be brutally honest, I haven't yet attempted to run workloads federated accross multiple cloud providers. But the reasonable thing to do, when thinking about the hurdles of terraform when working with multiple accounts and general code-overhead, when having to combine both multi-cloud and multi-env infrastructure I'd firstly lean into investigating whether or not Terragrunt would be a better layer of abstraction for that.


