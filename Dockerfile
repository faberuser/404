FROM oven/bun:alpine AS base

ARG NEXT_PUBLIC_METADATA_TITLE
ENV NEXT_PUBLIC_METADATA_TITLE=$NEXT_PUBLIC_METADATA_TITLE

ARG NEXT_PUBLIC_METADATA_DESCRIPTION
ENV NEXT_PUBLIC_METADATA_DESCRIPTION=$NEXT_PUBLIC_METADATA_DESCRIPTION

ARG NEXT_PUBLIC_PAGE_HEADING
ENV NEXT_PUBLIC_PAGE_HEADING=$NEXT_PUBLIC_PAGE_HEADING

ARG NEXT_PUBLIC_PAGE_MESSAGE
ENV NEXT_PUBLIC_PAGE_MESSAGE=$NEXT_PUBLIC_PAGE_MESSAGE

WORKDIR /usr/src/app

# install dependencies into temp directory
# this will cache them and speed up future builds
FROM base AS install-dev
RUN mkdir -p /temp/dev
COPY package.json bun.lock /temp/dev/
RUN cd /temp/dev && bun install --frozen-lockfile

# install with --production (exclude devDependencies)
FROM base AS install-prod
RUN mkdir -p /temp/prod
COPY package.json bun.lock /temp/prod/
RUN cd /temp/prod && bun install --frozen-lockfile --production

# copy node_modules from temp directory and source with populated submodules
FROM base AS prerelease
COPY --from=install-dev /temp/dev/node_modules node_modules
COPY . .

# build the application
RUN bun run build

# copy production dependencies and source code into final image
FROM base AS release
COPY --from=install-prod /temp/prod/node_modules ./node_modules
COPY --from=prerelease /usr/src/app/.next ./.next
COPY --from=prerelease /usr/src/app/package.json ./package.json

# expose the port
EXPOSE 3000

# start the application
ENTRYPOINT ["bunx"]
CMD ["next", "start", "-p", "3000", "-H", "0.0.0.0"]