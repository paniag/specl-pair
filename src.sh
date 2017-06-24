echo '-----> Creating a source code directory'
mkdir -p src

echo '-----> Installing Bazel'
sudo mkdir -p /etc/apt/sources.list.d
echo 'deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8' | sudo tee /etc/apt/sources.list.d/bazel.list
curl https://bazel.build/bazel-release.pub.gpg | sudo apt-key add -
sudo apt-get update && sudo apt-get install bazel
echo '> bazel version'
bazel version
cat >> src/WORKSPACE <<EOF
git_repository(
    name = 'protobuf',
    remote = 'https://github.com/google/protobuf',
    commit = 'v3.3.2',
)
EOF

echo '-----> Installing Go'
sudo apt-get install golang
mkdir -p src/go/{bin,pkg,src}
cat >> src/WORKSPACE <<EOF
# Go integration
git_repository(
  name = 'io_bazel_rules_go',
  remote = 'https://github.com/bazelbuild/rules_go.git',
  tag = '0.5.0',
)
load('@io_bazel_rules_go//go:def.bzl', 'go_repositories')
go_repositories()
EOF
cat >> src/BUILD <<EOF
# Go integration
load('@io_bazel_rules_go//go:def.bzl', 'go_prefix')
go_prefix('go/src')
EOF
