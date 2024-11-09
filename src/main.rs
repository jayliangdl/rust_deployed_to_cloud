use axum::{response::Html, routing::get, Router};
use tracing::info;
use std::env;
use rust_deployed_to_cloud::utils::logging::init_log;
#[tokio::main]
async fn main() {
    init_log().await; // 日志初始化
    // build our application with a route
    let port = env::var("PORT_SET_WHEN_RUN")
        .unwrap_or_else(|_| env::var("PORT").unwrap_or_else(|_| "3000".to_string()));
    let port_num = port.parse::<u16>().expect("PORT must be a number");

    let addr = format!("0.0.0.0:{}", port_num);  
    info!("server is going to start on {} ",&addr);
    
    let app = Router::new().route("/", get(handler));

    // run it
    let listener = tokio::net::TcpListener::bind(&addr)
        .await
        .unwrap();
    info!("server started on {}", listener.local_addr().unwrap());
    axum::serve(listener, app).await.unwrap();
}

async fn handler() -> Html<&'static str> {
    Html("<h1>Hello, World!</h1>")
}
