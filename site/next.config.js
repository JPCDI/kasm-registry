/** @type {import('next').NextConfig} */

const nextConfig = {
  env: {
    name: 'JPCDI Repo',
    description: 'The official JPCDI Repo for Kasm .',
    icon: '/img/logo.svg',
    listUrl: 'https://jpcdi.github.io/',
    contactUrl: 'https://kasmweb.com/support',
  },
  reactStrictMode: true,
  swcMinify: true,
  basePath: '/kasm-registry/1.0',
  trailingSlash: true,
  images: {
    unoptimized: true,
  }
}

module.exports = nextConfig
