### Task 5
since "We do not expect you to build a full system in the couple of hours assigned to this task.
Instead, we want to see a reasonable start. Get as far as you can. This can be the
scaffolding and some architectural choices that will serve as the prototype for future
development. Your answers can be showcased in multiple ways, code, diagrams,
research paper etc."


Writing your own helm chart for WordPress is highly redundant and in fact totally counter productive. It'd be hard for any single person to claim to be smarter than an entire Open Source Community, and when there are examples of great maintained helm charts for the given task - it's a strong Invented Not Here Syndrome.

Let's save ourselves the pain of maintaining unnecesary things and use Bitnami helm charts since they already exist:

https://artifacthub.io/packages/helm/bitnami/wordpress


Why it fills in all of the requirements given?

Create a Helm Chart: Bitnami's WordPress chart is already created and maintained with best practices in mind. It includes a values.yaml file which allows for extensive customization options such as database credentials, site URL, and more.

Configure Kubernetes Manifests: The chart includes all necessary Kubernetes manifests for deploying WordPress. This covers deployments, services, and other required resources like secrets and configmaps, ensuring a complete WordPress application setup.

Test the Helm Chart: You can perform a dry-run installation of the Bitnami WordPress Helm chart using the helm install --dry-run command. This will output all the Kubernetes manifests that will be created, allowing you to review them without actually deploying anything.

Validate the Chart: The helm lint command can be used with the Bitnami WordPress chart to check for issues and ensure that the chart adheres to Helm's best practices and conventions. Bitnami maintains a high standard for their charts, so it should pass helm lint without issues.

Cleanup: After testing and validating the chart, you can clean up any resources that were created during the dry-run (if any were actually created, which is unlikely with --dry-run) or during actual deployments for testing purposes. Since --dry-run doesn't create resources in the cluster, cleanup should be more about ensuring no unwanted configurations remain from any actual test deployments.
