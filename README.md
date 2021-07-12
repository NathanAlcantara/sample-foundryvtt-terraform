You have to create inside the files folder, a file called `aws.json` with a value about your aws account, something like this:

```json
{
    "accessKeyId": "...",
    "secretAccessKey": "...",
    "region": "..."
}
```

And at the same folder you have to put the foundryvtt.zip that you can download using your license (This is a temporary mesure)

After this you just initialize terraform: `terraform init`
And then you can plan and/or apply to your account and see the magic working! :tada: 