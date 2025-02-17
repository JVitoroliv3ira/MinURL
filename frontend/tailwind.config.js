/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{html,ts}"
  ],
  theme: {
    extend: {
      colors: {
        primary: "#1E3A8A",
        secondary: "#64748B",
        background: "#F8FAFC",
        card: "#FFFFFF",
        border: "#E2E8F0",
        text: "#1E293B",
        accent: "#2563EB",
        muted: "#94A3B8"
      },
      borderRadius: {
        DEFAULT: "8px",
        lg: "12px",
      },
      boxShadow: {
        md: "0 2px 4px rgba(0, 0, 0, 0.05)",
        lg: "0 4px 8px rgba(0, 0, 0, 0.08)",
      },
      fontFamily: {
        sans: ["Inter", "sans-serif"],
      }
    },
  },
  plugins: [require("daisyui")],
  daisyui: {
    themes: false,
  },
};
