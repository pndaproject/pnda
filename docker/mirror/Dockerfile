FROM centos:7.5.1804 as build

ARG PNDARELEASE=develop
# Can be HDP or CDH
ARG HADOOPDIST=HDP

RUN yum clean all && rm -rf /var/cache/yum/* && yum install gettext git -y

RUN git clone -b $PNDARELEASE https://github.com/pndaproject/pnda.git

WORKDIR /pnda/mirror
# Add the -r flag to mirror rpm packages
RUN ./create_mirror.sh -d $HADOOPDIST -r

WORKDIR /pnda/build
RUN ./install-build-tools.sh

RUN yum install bzip2 make which -y
RUN source ./set-pnda-env.sh \
    && ./build-pnda.sh BRANCH $PNDARELEASE $HADOOPDIST

FROM nginx:alpine

COPY --from=build /pnda/mirror/mirror-dist /usr/share/nginx/html/
COPY --from=build /pnda/build/pnda-dist /usr/share/nginx/html/

