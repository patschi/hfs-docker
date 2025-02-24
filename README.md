# HFS-Docker

This project automates the creation of Docker container images for the great GitHub project [HFS (HTTP File Server)](https://github.com/rejetto/hfs). The containers are built using Google's Distroless images, which are designed for small size, enhanced security, and therefore reduces any attack vectors. Distroless images exclude unnecessary packages (even no interactive shell), making them ideal for production environments where security and efficiency are critical. (Learn more about Distroless [here](https://github.com/GoogleContainerTools/distroless).)

Docker images for the HFS project **are built automatically here** using scheduled GitHub Actions. This ensures that the latest stable and non-prerelease versions of HFS are always effortlessly kept up-to-date. The **latest** version is tagged automatically, and Docker images are pushed to the GitHub Container Registry. (To avoid rate limits by Docker Hub and have one single convenient place to look for)

## Key Features

- **Automated Builds**: Docker images are **automatically built** (_on a schedule, not immediately_) when a new release is published on the HFS-GitHub repository. This includes stable and pre-releases. The `latest` tag does always refer to the latest stable release. Builds are automatically tested if they start before publishing.
- **Distroless Base Images**: Images are kept minimal, small in size, secure, and free from unnecessary packages or shells.
- **Security**: Distroless images do not provide package managers, shells or any other unnecessary tools. This reduces any attack vectors.
- **Rootless**: The container runs **rootless** (UID 65532), and the HFS application also runs without root privileges for additional security.
- **Compactness**: This image only contains the absolutely bare minimum to have HFS running. It is barely larger than the HFS binary itself.

## Issues/Feedback/Support

Should you encounter any issue, please do following first:

1. Try the [latest available image on GitHub](https://github.com/patschi/hfs-docker/pkgs/container/hfs-docker/versions) and check if the issue still exists.

2. If issue persists, please check if your issue is already known or was already addressed:
   - [GitHub issues for the image](https://github.com/patschi/hfs-docker/issues?q=is%3Aissue), if the issue is specific to the container image.
   - [GitHub issues for HFS as an application](https://github.com/rejetto/hfs/issues?q=is%3Aissue), if the issue is specific to HFS as the application.

3. If no luck, open a issue depending on where the issue relies. Include as much details as possible to help understanding your issue and your environment.

## Usage and Updates

Everyone is welcome to use these Docker images. If you want to keep your HFS container up-to-date automatically, you can use the [Watchtower GitHub project](https://github.com/containrrr/watchtower), which monitors and updates running containers. Alternatively, you can also use the built-in in-app update feature of HFS to stay current with new versions.

**Note**: Keep in mind, that the user `nonroot` (UID 65532/GID 65532) within the container might need permissions on the volume binds on the host.

### Run Container

**To run the docker container directly:**

```shell
docker run -d
  -p 80:80 \
  -p 443:443 \
  -e HFS_CREATE_ADMIN=Password123 \
  -v /opt/hfs-config/:/app/config/ \
  -v /mnt/your-data:/data \
  ghcr.io/patschi/hfs-docker:latest
```

**Using docker-compose.yml:** (or `compose.yml`)

```yaml
services:
  hfs:
    image: ghcr.io/patschi/hfs-docker:latest
    volumes:
      - /opt/hfs-config/:/app/config/ # All config, SSL keys, plugins will be saved there. Needed to have settings persisted.
      - /mnt/your-data:/data # This mount local /mnt/your-data/ to /data inside the container. Configure HFS to check /data then.
    environment:
      - HFS_PORT=8080 # Change default port from 80 to 8080.
      - HFS_CREATE_ADMIN=Password123 # This will create the admin user with pre-defined password.
    ports:
      - 8080:8080
```

Followed by:

```shell
docker compose up -d
```

### Environment Variables

The application HFS is capable of understanding environment variables to change certain settings, in addition to the easy-to-change `config.yml` it creates. All available settings and further guidance can be checked out on [github.com/rejetto/hfs/blob/main/config.md#how-to-modify-configuration](https://github.com/rejetto/hfs/blob/main/config.md#how-to-modify-configuration).

For example:

- If you want to change `create-admin`, you can use environment variable `HFS_CREATE_ADMIN`.
- If you want to have HFS listen on a different port using `port`, you can change environment variable `HFS_PORT`

## Where to Find the Container Images

The Docker images for HFS are hosted on the GitHub Container Registry under the `ghcr.io/patschi/hfs-docker` repository. You can see [all available images here](https://github.com/users/patschi/packages/container/package/hfs-docker). Images can be pulled by using the following formats:

To pull the **latest version**:

```text
docker pull ghcr.io/patschi/hfs-docker:latest
```

To pull a **specific version**:

```text
docker pull ghcr.io/patschi/hfs-docker:v0.54.0
```
