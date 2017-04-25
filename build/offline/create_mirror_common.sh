export DISTRO=$(awk -F= '/^ID=/ { print $2 }' /etc/*-release|tr -d \")

[[ -z ${MIRROR_BUILD_DIR} ]] && export MIRROR_BUILD_DIR=${PWD}
[[ -z ${MIRROR_OUTPUT_DIR} ]] && export MIRROR_OUTPUT_DIR=${PWD}/mirror-dist

function download() {
    [[ $# -lt 1 ]] && { echo 'No URL specified!'; return 1; }
    curl --location --remote-name --remote-header-name $@
}
