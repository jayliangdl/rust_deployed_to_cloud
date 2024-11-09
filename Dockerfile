# 使用基于Linux的Rust官方镜像，版本1.80.0
FROM docker.io/library/rust:1.80.0 as builder

#从Github上下载配置项目的文件
WORKDIR /home/cn087005/run_env/config
RUN git clone -b test https://jayliangdl@github.com/jayliangdl/rust_config_deploy_to_cloud.git

# 将配置文件拷贝到运行目录
RUN mkdir -p /home/cn087005/run_env/release \
    && cp -r /home/cn087005/run_env/config/rust_config_deploy_to_cloud/.env.test /home/cn087005/run_env/release/.env


# 设置工作目录
WORKDIR /home/cn087005/run_env/app

#从GitHub上下载源代码（https://github.com/jayliangdl/rust_deployed_to_cloud.git）
RUN git clone https://jayliangdl@github.com/jayliangdl/rust_deployed_to_cloud.git

WORKDIR /home/cn087005/run_env/app/rust_deployed_to_cloud

RUN cp -r /home/cn087005/run_env/config/rust_config_deploy_to_cloud/.env.test /home/cn087005/run_env/app/rust_deployed_to_cloud/.env
# 构建项目
RUN cargo build --release

RUN cp -r /home/cn087005/run_env/app/rust_deployed_to_cloud/target/release/rust_deployed_to_cloud /home/cn087005/run_env/release/
# 将构建好的二进制文件拷贝到运行目录

# 创建最终的精简镜像
FROM debian:bookworm-slim

# 设置环境变量
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    libssl3 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /home/cn087005/run_env/release/* /home/cn087005/run_env/release/

#检查 .env 文件路径
RUN ls -la /home/cn087005/run_env/release/

WORKDIR /home/cn087005/run_env/release/
# 启动应用
CMD ["./rust_deployed_to_cloud"]