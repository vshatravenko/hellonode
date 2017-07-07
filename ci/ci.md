# Concourse CI pipeline config

## Deploy

Go to the CI site
```
https://ci.bloomon.io/
```

Download CLI tools

Log in to a team
```
fly --target bloomon login --team-name main \
    --concourse-url https://ci.bloomon.io
```

Set pipeline
```
fly -t bloomon set-pipeline -p hellonode -c ci/pipeline.yml -l ci/credentials.yml
```

Unpause pipeline
```
fly -t bloomon unpause-pipeline -p hellonode
```

Go to https://ci.bloomon.io/teams/main/pipelines/hellonode
