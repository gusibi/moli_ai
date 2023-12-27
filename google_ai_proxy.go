package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"net/url"
)

func main() {
	// 下面的URL应该被替换成你需要转发到的服务的URL
	targetServiceURL := "https://generativelanguage.googleapis.com"

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		// 创建一个新的请求
		targetUrl := targetServiceURL + r.URL.Path
		baseUrl, err := url.Parse(targetUrl)
		if err != nil {
			panic(err)
		}
		// 创建并设置查询参数
		params := url.Values{}
		for k, v := range r.URL.Query() {
			params.Add(k, v[0])
		}
		baseUrl.RawQuery = params.Encode()
		targetUrl = baseUrl.String()
		fmt.Println("url: ", targetUrl)
		req, err := http.NewRequest(r.Method, targetUrl, r.Body)
		if err != nil {
			http.Error(w, "Error in request", http.StatusBadRequest)
			return
		}

		// 复制请求头
		for name, values := range r.Header {
			req.Header[name] = values
		}

		// 发送请求
		resp, err := http.DefaultClient.Do(req)
		if err != nil {
			http.Error(w, "Error in forward", http.StatusInternalServerError)
			return
		}
		defer resp.Body.Close()

		// 复制响应头
		for name, values := range resp.Header {
			w.Header()[name] = values
		}

		// 复制响应体
		_, err = io.Copy(w, resp.Body)
		if err != nil {
			http.Error(w, "Error in copy response", http.StatusInternalServerError)
		}
	})

	// 启动HTTP服务器
	log.Fatal(http.ListenAndServe(":8080", nil))
}
