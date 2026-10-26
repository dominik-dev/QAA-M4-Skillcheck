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