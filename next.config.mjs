/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    serverComponentsExternalPackages: ["mysql2"],
  },
  reactStrictMode: true,
  webpack(config) {
    config.resolve.extensions.push('.ts', '.tsx');
    return config;
  }
};

export default nextConfig;
