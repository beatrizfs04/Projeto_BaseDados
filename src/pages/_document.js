import { Html, Head, Main, NextScript } from "next/document";
import { SessionProvider } from 'next-auth/react'
import { useEffect, useState } from 'react'

export default function Document() {
  return (
    <SessionProvider>
      <Html lang="en">
        <Head />
        <body>
          <Main />
          <NextScript />
        </body>
      </Html>
    </SessionProvider>
  );
}
