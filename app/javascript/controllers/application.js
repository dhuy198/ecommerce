import { Application } from "@hotwired/stimulus";

const application = Application.start();

// Configure Stimulus development experience
application.debug = false;
window.Stimulus = application;

export { application };

const swiper = new Swiper(".swiper", {
  // Optional parameters
  loop: true,

  // Navigation arrows
  navigation: {
    nextEl: ".swiper-button-next",
    prevEl: ".swiper-button-prev",
  },
});

document.addEventListener("DOMContentLoaded", () => {
  const flash = document.getElementById("flash-alert");
  if (flash) {
    flash.classList.remove("hidden");
    setTimeout(() => {
      flash.classList.add("opacity-0");
      setTimeout(() => flash.remove(), 500); // Xóa hẳn sau khi mờ đi
    }, 4000); // Hiển thị 4 giây
  }
});

window.showAlert = function (message, type = "error") {
  const box = document.getElementById("alert-box");
  const msg = document.getElementById("alert-message");

  if (!box || !msg) return;

  box.className = `
    fixed top-6 right-6 z-50 w-[320px] max-w-[90%]
    px-5 py-4 rounded-2xl shadow-xl
    text-base font-medium text-white
    transition-all duration-300 ease-in-out
    backdrop-blur-sm
  `.trim();

  switch (type) {
    case "success":
      box.classList.add("bg-green-500/90");
      break;
    case "info":
      box.classList.add("bg-blue-500/90");
      break;
    case "warning":
      box.classList.add("bg-yellow-400", "text-black");
      break;
    default:
      box.classList.add("bg-red-500/90");
  }

  msg.textContent = message;
  box.classList.remove("hidden");

  setTimeout(() => {
    box.classList.add("hidden");
  }, 4000);
};
