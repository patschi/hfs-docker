# HFS-Docker

This project automates the creation of Docker containers for the [HFS (HTTP File Server)](https://github.com/rejetto/hfs) GitHub project. The containers are built using Google's Distroless images, which are designed for small size, enhanced security, and therefore reduces any attack vectors. Distroless images exclude unnecessary packages (even no interactive shell), making them ideal for production environments where security and efficiency are critical. Learn more about Distroless [here](https://github.com/GoogleContainerTools/distroless).

Docker images for the HFS project are built automatically using **GitHub Actions**. This ensures that the latest stable and non-prerelease versions of HFS are always effortlessly kept up-to-date. The **latest** version is tagged automatically, and Docker images are pushed to the GitHub Container Registry. (To avoid rate limits by Docker Hub and have one single convenient place to look for)

## Key Features

- **Distroless Base Images**: Images are kept minimal, secure, and free from unnecessary packages or shells.
- **Automated Builds**: Docker images are automatically built when a new release is published on the HFS-GitHub. (periodically scheduled, not instant)
- **Security**: Distroless images provide less packets, therefore less attack vectors, due to the lack of package managers, unnecessary tools and shells.
- **Rootless**: The container runs **rootless**, and the HFS application also runs without root privileges for added security.

## Usage and Updates

Everyone is welcome to use these Docker images. If you want to keep your HFS container up-to-date automatically, you can use the [Watchtower GitHub project](https://github.com/containrrr/watchtower), which monitors and updates running containers. Alternatively, you can also use the built-in in-app update feature of HFS to stay current with new versions.

## Where to Find the Docker Images

The Docker images for HFS are hosted on the **GitHub Container Registry** under the `ghcr.io/patschi/hfs-docker` repository. You can pull the images using the following formats:

To pull the **latest version**:

```text
ghcr.io/patschi/hfs-docker:latest
```
