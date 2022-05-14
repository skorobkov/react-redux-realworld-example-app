ARG NODE_VERSION=slim

FROM node:${NODE_VERSION} AS build
RUN useradd -d /project -m build
USER build
WORKDIR /project
COPY --chown=build:build . /project
RUN npm install
RUN npm run build

FROM node:${NODE_VERSION}
ENV PORT=3000
RUN npm install -g serve && \
    useradd -m serve
USER serve
WORKDIR /project
COPY --chown=serve:serve --from=build /project/build /project

CMD [ "serve", "--no-clipboard", "--listen", "tcp://0.0.0.0:${PORT}", "/project" ]