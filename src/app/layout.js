import { Inter } from "next/font/google";
import "./globals.css";

const inter = Inter({ subsets: ["latin"] });

export const metadata = {
  title: "Projeto Base de Dados",
  description: "Projeto de Base de Dados Criado Por Rodrigo Paiva (A49442), Beatriz Santos (AXXXXX), Manoela Azevedo (AXXXXX)",
};

export default function RootLayout({ children }) {
  return (
    <html lang="pt">
      <body className={inter.className}>{children}</body>
    </html>
  );
}
