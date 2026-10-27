Project to dest docker, kubernetes skills


### Commands

Setup test node
`kind create cluster --name skillcheck-project`
`k get nodes`

Deploy kubernetes pods
`k apply -f deployment.yaml`

`k get deployments,pods,services`

Pods were "pending" debug with:
`k get pods -o wide`

The images were not available in local node so to upload them do:
`kind load docker-image <image name> --name <cluster>`

### Jenkins pipeline

Configure the job as **Pipeline script from SCM**, select the repository and
branch, and set **Script Path** to `codebase/JenkinsFile`. Jenkins checks out that
branch, builds both Docker images, pushes them to Docker Hub, and runs
`codebase/k8s-deploy.sh` to deploy and wait for both rollouts.

Prerequisites:

- The Linux Jenkins agent must have Bash, Git, Docker, and kubectl installed,
  access to the Docker daemon, and network access to Docker Hub and Kubernetes.
- Add a Jenkins **Username with password** credential with ID
  `dockerhub-credentials`. Use your Docker Hub username and an access token with
  write access to `dddominik/sc-backend` and `dddominik/sc-frontend`.
  This is separate from the GitHub checkout credential configured in the job.
- Both Docker Hub repositories must be public for the current Kubernetes
  manifests. Private repositories additionally require Kubernetes image pull
  credentials.
- The Jenkins agent's user must have a working kubeconfig with context
  `kind-skillcheck-project` and permission to apply Deployments and Services in
  its configured namespace. A kubeconfig available only to your WSL login user
  is not automatically available to Jenkins. A containerized agent also needs
  a reachable Kubernetes API address, not the host's loopback address.

Images use the checked-out commit's first 12 characters plus the Jenkins build
number as their tag. The deployment script substitutes that tag in the manifest
without changing the checked-in `v1` defaults. It does not build or push images.
To deploy an already-pushed tag manually:

```bash
bash codebase/k8s-deploy.sh <image-tag>
```

The script defaults to context `kind-skillcheck-project`. Set `KUBE_CONTEXT` to
override it; for Jenkins, change the pipeline's environment setting. The script
exits unsuccessfully if applying resources or either rollout fails.