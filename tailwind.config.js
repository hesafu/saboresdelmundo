/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./**/*.{html,js}",
    "./pages/**/*.{html,js}",
    "./components/**/*.{html,js}"
  ],
  theme: {
    extend: {
      fontFamily: {
        'sans': ['Open Sans', 'sans-serif'],
           primary: '#FF6B35',
        
      },
      colors: {
        'primary': '#FF6B35',
        'secondary': '#2EC4B6',
        'accent': '#FFBF69',
        'dark': '#1A535C',
        'light': '#F7FFF7',
      },
    },
  },
  plugins: [],
}
