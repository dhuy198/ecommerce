import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["text"];

  update() {
    let wishlist = JSON.parse(localStorage.getItem("wishlist")) || [];
    const productId = this.element.dataset.productId;
    const name = this.element.dataset.productName;
    const price = parseFloat(this.element.dataset.productPrice);
    const category_name = this.element.dataset.categoryName;
    const imageUrl = this.element.dataset.imageUrl;

    const params = {
      id: productId,
      name: name,
      price: price,
      category_name: category_name,
      image_url: imageUrl,
    };
    const exists = wishlist.some((item) => item.id === productId);

    if (exists) {
      wishlist = wishlist.filter((item) => item.id !== productId);

      localStorage.setItem("wishlist", JSON.stringify(wishlist));
      const navbarCount = document.getElementById("wlnloginCount");
      navbarCount.innerText = wishlist.length;
      this.element.classList.remove("fill-red-400");
      this.element.classList.add("fill-none");
    } else {
      wishlist.push(params);
      localStorage.setItem("wishlist", JSON.stringify(wishlist));

      const navbarCount = document.getElementById("wlnloginCount");
      navbarCount.innerText = wishlist.length;

      this.element.classList.remove("fill-none");
      this.element.classList.add("fill-red-400");
    }
  }

  connect() {
    const wishlist = JSON.parse(localStorage.getItem("wishlist")) || [];
    const navbarCount = document.getElementById("wlnloginCount");
    navbarCount.innerText = wishlist.length;
    const productId = this.element.dataset.productId;
    wishlist.forEach((item) => {
      if (item.id === productId) {
        this.element.classList.remove("fill-none");
        this.element.classList.add("fill-red-400");
      }
    });
    const container = document.getElementById("wl-container");
    if (container) {
      if (wishlist.length === 0) {
        container.innerHTML = `
        <p class="text-center text-gray-500 mt-10">Wishlist của bạn đang trống</p>
        `;
        return;
      }

      container.innerHTML = wishlist
        .map(
          (item) => `
      <div class="group bg-white rounded-3xl shadow-md hover:shadow-xl transform hover:scale-[1.02] border border-gray-200 overflow-hidden flex flex-col transition-all duration-300">
        <!-- Image -->
        <div class="relative">
          ${
            item.image_url
              ? `<img class="w-full h-64 object-scale-down transition-transform duration-300 group-hover:scale-105" src="${item.image_url}" alt="${item.name}">`
              : `<div class="w-full h-64 bg-gray-100 flex items-center justify-center text-gray-400 text-lg">No Image</div>`
          }
          <!-- Remove Button -->
          <div class="absolute top-3 right-3 z-10">
            <svg 
          xmlns="http://www.w3.org/2000/svg" 
          fill="none" 
          viewBox="0 0 24 24" 
          stroke-width="1.5" 
          stroke="currentColor" 
          class="size-6 cursor-pointer"
          
          >
          <path stroke-linecap="round" stroke-linejoin="round" d="M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12Z" />
        </svg>
          </div>
        </div>

        <!-- Info -->
        <div class="p-5 flex flex-col flex-1 justify-between">
          <div>
            <h3 class="text-lg font-semibold text-gray-900 mb-1 line-clamp-1">${
              item.name
            }</h3>
            <p class="text-sm text-gray-500 mb-3">
              <span class="hover:underline">${item.category_name}</span>
            </p>
          </div>
          
          <div class="mt-auto">
            <div class="flex justify-between items-center mb-4">
              <span class="text-xl font-bold text-[#152420]">$${item.price.toLocaleString()}</span>
            </div>
            <!-- Action Buttons -->
            <div class="flex gap-2">
              <a href="/products/${item.id}"
                class="flex-1 bg-[#152420] text-white text-sm font-medium py-2 px-3 rounded-lg hover:bg-[#23403D] transition-colors text-center inline-flex items-center justify-center gap-1">
                <i class="fas fa-eye"></i> View
              </a>
              
            </div>
          </div>
        </div>
      </div>
    `
        )
        .join("");
    }
  }
}
