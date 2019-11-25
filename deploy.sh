docker build -t alfredlebeau/multi-client:latest -t alfredlebeau/multi-client:$SHA -f ./client/Dockerfile ./client
#./client/Dockerfile is the location of the docker file and ./client is the context ... usually just typed a "."
docker build -t alfredlebeau/multi-server:latest -t alfredlebeau/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t alfredlebeau/multi-worker:latest -t alfredlebeau/multi-worker:$SHA -f ./worker/Dockerfile ./worker
# to ge the SHA value:  git rev-parse HEAD ... will return something like d5701ac9d2359db84a3047d6ebfafa6a4f7fa97d
# so for above it's really -t alfredlebeau/multi-worker:d5701ac9d2359db84a3047d6ebfafa6a4f7fa97d


docker push alfredlebeau/multi-client:latest
docker push alfredlebeau/multi-server:latest
docker push alfredlebeau/multi-worker:latest

docker push alfredlebeau/multi-client:$SHA
docker push alfredlebeau/multi-server:$SHA
docker push alfredlebeau/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=alfredlebeau/multi-server:$SHA
kubectl set image deployments/client-deployment client=alfredlebeau/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=alfredlebeau/multi-worker:$SHA