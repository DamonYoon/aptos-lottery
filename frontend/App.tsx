import { RouterProvider, createBrowserRouter, Outlet } from "react-router-dom";
import { Header } from "./components/Header";
// Internal pages

function Layout() {
  return (
    <>
      <Header />
      <Outlet />
    </>
  );
}

const router = createBrowserRouter([
  {
    element: <Layout />,
    children: [
      {
        path: "/",
        element: <>Home</>,
      },
    ],
  },
]);

function App() {
  return (
    <div className="w-screen h-screen">
      <RouterProvider router={router} />
    </div>
  );
}

export default App;
