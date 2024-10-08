import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App.jsx";
import "./index.css";
import { QueryClient } from "@tanstack/react-query";
import { ReactQueryDevtools } from "@tanstack/react-query-devtools";
import { useFetchAndCacheTrades } from "@hooks/useFetchAndCacheTrades";

// const queryClient = new QueryClient({
//   defaultOptions: {queries: {staleTime: 1000 * 60 * 1}},
// })
const queryClient = new QueryClient();
const { prefetchTrades } = useFetchAndCacheTrades();
prefetchTrades();

ReactDOM.createRoot(document.getElementById("root")).render(
  <React.StrictMode>
    <QueryClientProvider client={queryClient}>
      <App />
      <ReactQueryDevtools initialIsOpen={false} />
    </QueryClientProvider>
  </React.StrictMode>
);
