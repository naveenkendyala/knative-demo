# Application Architecture Choices : Monolith, 2 Tier Architectures, N-Tier Architectures, Cloud Native, Micro-services, Serverless
# History : Needs of Serverless
# Knative
# Typical Application Requirements : Deployment, HPA, Service, and Route

# Knative
# HPA does not scale down to zero. KPA can do that

# Knative has few things
  # Knative Serving
  # Knative Eventing
  # Knative Functions
  # Knative CLI

# Show where to download the command line tools

# Cretae and change t/globalhe project
oc new-project demo-knative

# Create a Service
kn service create hello-knative --image="quay.io/naveenkendyala/quarkus-demo-quarkusjvm-hello:v1"
kn service list

# Send traffic and talk about the container concurrency
hey -c 50 -z 10s https://hello-knative-demo-knative.apps.cluster-8d8g9.8d8g9.sandbox2115.opentlc.com/api/hello

# Show kpa resources and talk about the concurrency
oc get kpa

# Talk about revisions
# Update the service to a newer revision
kn service update hello-knative --image="quay.io/naveenkendyala/quarkus-demo-quarkusjvm-hello:v1" --scale-target=10 --scale-max=5 --scale-window="10s"

# Show revisions
kn revision list

# Send traffic and show the increase in pod count
hey -c 50 -z 20s https://hello-knative-demo-knative.apps.cluster-8d8g9.8d8g9.sandbox2115.opentlc.com/api/hello

# Show revisions
kn revision list

# Traffic Switching
kn service update hello-knative --traffic version01=1 --traffic version02=99
kn service update hello-knative --traffic hello-knative-00002=1 --traffic hello-knative-00001=99
kn service update hello-knative --traffic hello-knative-00002=1 --traffic hello-knative-00001=99

# Send traffic and show the increase in pod count
hey -c 50 -z 10s https://hello-knative-demo-knative.apps.cluster-8d8g9.8d8g9.sandbox2115.opentlc.com/api/hello

# Talk about the scale down time that was different between the versions


# Generate load to the End Point
# -c  Number of workers to run concurrently. Total number of requests cannot be smaller than the concurrency level. Default is 50.
# -z  Duration of application to send requests. When duration is reached, application stops and exits. If duration is specified, n is ignored.
# Examples: -z 10s -z 3m.
hey -c 50 -z 10s https://hello-knative-demo-knative.apps.cluster-8d8g9.8d8g9.sandbox2115.opentlc.com/api/hello


# Knative control plane
# Controller gets the request : Checks to see if anything is running
# Id none are running, a request is sent to the activator which instructs k8s to spin a pod
# Pod comes up online and starts serving the request
# Pod also comes with another container that sends metrics to the activator
# Activator decides if more pods are needed based on concurrency
# Activator informs the k8s
# Pods are scaled accordingly,. This continues to happen based on the set max scale


hey -n 5000 -c 50 https://sboot-rest-demo-knative-advanced.apps.cluster-nfvjp.nfvjp.sandbox145.opentlc.com/todos
hey -n 5000 -c 50 https://quarkus-rest-demo-knative-advanced.apps.cluster-nfvjp.nfvjp.sandbox145.opentlc.com/todos


curl -X POST -H "Content-Type: text/plain" -d 'Sample Message' https://camel-sboot-rest-amq-demo-amq-dc.apps.cluster-dpspl.dpspl.sandbox1092.opentlc.com/camel/send-message
curl -X POST -H "Content-Type: application/json" -d '{"name": "linuxize", "email": "linuxize@example.com"}' https://camel-sboot-rest-amq-demo-amq-dc.apps.cluster-dpspl.dpspl.sandbox1092.opentlc.com/camel/send-message
hey -m POST -n 500 -c 10 -d "WooHoo" https://camel-sboot-rest-amq-demo-amq-dc.apps.cluster-dpspl.dpspl.sandbox1092.opentlc.com/camel/send-message
