workflow "Leave buildinfo comment when a PR is merged" {
  on = "pull_request"
  resolves = ["GraphQL query"]
}

action "PR merged" {
  uses = "actions/bin/filter@master"
  args = "merged true"
}

action "Leave a comment" {
  uses = "swinton/httpie.action@8ab0a0e926d091e0444fcacd5eb679d2e2d4ab3d"
  needs = ["PR merged"]
  secrets = ["GITHUB_TOKEN"]
}

action "GraphQL query" {
  uses = "helaili/github-graphql-action@fb0ce78d56777b082e1a1659faf2b9f5a8832ed3"
  needs = ["Leave a comment"]
}
