import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["text"];

  update() {
    if (this.element.dataset.status === "false") {
      const productId = this.element.dataset.productId;
      this.add(productId);
    } else {
      const productId = this.element.dataset.productId;
      this.remove(productId);
    }
  }

  add(productId) {
    let wishlist = JSON.parse(localStorage.getItem("wishlist")) || [];

    if (!wishlist.includes(productId)) {
      wishlist.push(productId);
      localStorage.setItem("wishlist", JSON.stringify(wishlist));

      this.element.classList.remove("fill-none");
      this.element.classList.add("fill-red-400");
      this.element.dataset.status = "true";

      this.updateNavbarCount(1);
      console.log("Added:", productId, "Wishlist:", wishlist);
    }
  }

  remove(productId) {
    let wishlist = JSON.parse(localStorage.getItem("wishlist")) || [];

    wishlist = wishlist.filter((id) => id !== productId);
    localStorage.setItem("wishlist", JSON.stringify(wishlist));

    this.element.classList.remove("fill-red-400");
    this.element.classList.add("fill-none");
    this.element.dataset.status = "false";

    this.updateNavbarCount(-1);
    console.log("Removed:", productId, "Wishlist:", wishlist);
  }

  updateNavbarCount(change) {
    let navbar = document.getElementById("wlnloginCount");
    const cnt = parseInt(navbar.dataset.wishlistCount || "0");
    const newCount = Math.max(cnt + change, 0);
    navbar.innerText = newCount;
    navbar.dataset.wishlistCount = newCount;
  }

  connect() {
    // Khởi tạo count khi load trang
    const wishlist = JSON.parse(localStorage.getItem("wishlist")) || [];
    let navbar = document.getElementById("wlnloginCount");
    navbar.innerText = wishlist.length;
    navbar.dataset.wishlistCount = wishlist.length;
  }
}
