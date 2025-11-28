#!/bin/bash
set -e

PROJECT_NAME=$1

if [ -z "$PROJECT_NAME" ]; then
  echo "Bitte Projektname angeben!"
  echo " Beispiel: ./create-vite-react.sh myapp"
  exit 1
fi

echo "Erstelle Vite + React + Tailwind Projekt: $PROJECT_NAME"

printf "n\nn\n" | pnpm create vite@latest "$PROJECT_NAME" --template react

cd "$PROJECT_NAME"

echo "Installiere Dependencies..."
pnpm install

echo "Installiere TailwindCSS..."
pnpm add tailwindcss @tailwindcss/vite

echo "Konfiguriere vite.config.js..."
cat > vite.config.js <<EOF
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  plugins: [
    react(),
    tailwindcss(),
  ],
})
EOF

echo "Installiere Prettier + Tailwind Prettier Plugin..."
pnpm add -D prettier prettier-plugin-tailwindcss

echo "Erstelle .prettierrc.cjs..."
cat > .prettierrc.cjs <<EOF
/** @type {import("prettier").Config} */
module.exports = {
  "plugins": ["prettier-plugin-tailwindcss"],
  semi: true,
  singleQuote: false,
  trailingComma: "es5",
  tabWidth: 2,
  printWidth: 100,
};
EOF

echo "Erstelle .prettierignore..."
cat > .prettierignore <<EOF
node_modules
dist
build
EOF

echo "Schreibe src/index.css..."
cat > src/index.css <<EOF
@import "tailwindcss";
EOF

echo "Erstelle Startseite (src/App.jsx)..."
cat > src/App.jsx <<EOF
function App() {
  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-slate-50 text-slate-800 relative overflow-hidden">
      <div className="absolute top-0 left-0 w-full h-full bg-linear-to-br from-transparent via-transparent to-slate-200/50 pointer-events-none"></div>
      <div className="relative group z-10">
        <div className="relativeleading-none flex flex-col items-center justify-center max-w-lg w-full">
          <div className="flex items-center space-x-2 bg-slate-100 px-3 py-1 rounded-full border border-slate-200">
            <span className="relative flex h-2 w-2">
              <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75"></span>
              <span className="relative inline-flex rounded-full h-2 w-2 bg-emerald-500"></span>
            </span>
            <span className="text-xs font-medium text-slate-500 tracking-wide uppercase">System Online</span>
          </div>
          <div className="text-center mt-4">
            <h1 className="text-4xl md:text-5xl font-light tracking-tight text-slate-900">
              Vite + React
            </h1>
            <p className="text-slate-400 font-light text-lg tracking-wide">
              & Tailwind CSS
            </p>
          </div>
          <div className="flex flex-wrap justify-center gap-3 pt-4">
             {['Vite', 'React', 'Tailwind v4'].map((tech) => (
               <span key={tech} className="px-3 py-1 text-xs font-medium text-slate-600 bg-slate-100 rounded-md border border-slate-200 transition-colors hover:bg-slate-200 hover:text-slate-800 cursor-default">
                 {tech}
               </span>
             ))}
          </div>
        </div>
      </div>
    </div>
  );
}

export default App;
EOF

echo ""
echo "Fertig! Projekt erstellt in: $PROJECT_NAME"
echo "cd $PROJECT_NAME"
echo "pnpm dev"