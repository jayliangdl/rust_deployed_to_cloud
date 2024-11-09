use axum::{response::Html, routing::get, Router};
use std::env;

#[tokio::main]
async fn main() {
    // build our application with a route
    let port = env::var("PORT_SET_WHEN_RUN")
        .unwrap_or_else(|_| env::var("PORT").unwrap_or_else(|_| "3000".to_string()));
    let port_num = port.parse::<u16>().expect("PORT must be a number");

    let addr = format!("0.0.0.0:{}", port);  
    
    let app = Router::new().route("/", get(handler));

    // run it
    let listener = tokio::net::TcpListener::bind(&addr)
        .await
        .unwrap();
    println!("listening on {}", listener.local_addr().unwrap());
    axum::serve(listener, app).await.unwrap();
}

async fn handler() -> Html<&'static str> {
    Html("<h1>Hello, World!</h1>")
}
