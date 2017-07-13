# Concourse CI pipeline config

## Preparing tools

1. Go to the [CI site](https://ci.bloomon.io/)
2. Download CLI tools
3. Log in to a team
```console
fly --target bloomon login --team-name main \
    --concourse-url https://ci.bloomon.io
```

## Getting credentials

You should have some secrets to make the pipeline work (we don't want this secrets to be public). Check `credentials-example.yml` for more info. Don't forget to add `github_repo_url`, `github_repo` and `gcr_repo`.

### k8s credentials

This command will automatically add kubernetes secrets to `credentials.yml`.

```console
export secrets=(kubelet_key kubelet_cert ca_cert)
for secret in $secrets;
do;
  gcloud compute --project "bloomon-dev" ssh                               \
    --zone "europe-west1-b" "gke-stage-cluster-default-pool-9e2b2fc4-2nv0" \
    --command="cat /home/kubernetes/kube-env" | grep -i $secret |          \
    sed -e "s/^.\{10,25\}=/$secret: /" >> ci/credentials.yml;
done
gcloud compute --project "bloomon-dev" ssh                                 \
  --zone "europe-west1-b" "gke-stage-cluster-default-pool-9e2b2fc4-2nv0"   \
  --command="cat /home/kubernetes/kube-env" |                              \
  grep -i KUBERNETES_MASTER_NAME |                                         \
  sed -e 's/readonly KUBERNETES_MASTER_NAME=/kubernetes_host: https:\/\//' \
  >> ci/credentials.yml;
```

### GitHub

1. Add your github api key to `credentials.yml`:
```yaml
github_token: '00000000your000api000token00000000000000000000000'
```
2. Generate ssh keys pair
3. Add github private key like here
```yaml
github_private_key: |
  -----BEGIN RSA PRIVATE KEY-----
  0000000000000000000000000000000000000000000000000000000000000000
  000000private00000000key0000000000000000000000000000000000000000
  00000000000000000000000000000000000000000000000000000000
  -----END RSA PRIVATE KEY-----
```
4. Add your public key to github
5. Add your repo url to credentials.yml

## Setting the pipeline

Set pipeline

```console
fly -t bloomon set-pipeline -p hellonode -c pipeline.yml -l credentials.yml
```

Unpause pipeline

```console
fly -t bloomon unpause-pipeline -p hellonode
```

Go to https://ci.bloomon.io/teams/main/pipelines/hellonode to see the pipeline work.

## Testing

Let's try a simple workflow. First make sure [hello.bloomon.io](https://hello.bloomon.io) is online. Now you can try to make a simple change of `script.js` (change text, add image, add some styles, you name it). Commit the change, push to some tmp branch (like `git push origin HEAD:tmp`). Check your github and make a pull request to the repo you set up the pipeline for.

Feel free to visit [ci dashboard](https://ci.bloomon.io/teams/main/pipelines/hellonode) and see how some jobs triggers (build -> test -> set pr status). When 'test-pull-request' job is finished, check you pull request and see it's status.

Now try to merge this pull request. Again, go to [ci dashboard](https://ci.bloomon.io/teams/main/pipelines/hellonode) and watch the deployment process (build -> test -> deploy). After the deploy job is finished, check [hello.bloomon.io](https://hello.bloomon.io) and see the changes applied (if they aren't - wait a minute and reload the page).

