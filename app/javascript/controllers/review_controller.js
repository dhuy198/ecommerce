import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["comment", "stars", "errors"];
  selectedStarValue = 0;

  setStar(event) {
    this.selectedStarValue = parseInt(event.currentTarget.dataset.value);

    const stars = this.starsTarget.querySelectorAll("svg");
    stars.forEach((star, index) => {
      if (index < this.selectedStarValue) {
        star.classList.add("text-yellow-400");
        star.classList.remove("text-gray-300");
      } else {
        star.classList.add("text-gray-300");
        star.classList.remove("text-yellow-400");
      }
    });
  }

  submit() {
    const comment = this.commentTarget.value;
    const star = this.selectedStarValue;
    const productId = this.element.dataset.productId;

    if (star < 1 || star > 5) {
      this.showErrors(["Vui lòng chọn số sao đánh giá (1–5)."]);
      return;
    }
    const params = {
      comment: comment,
      star: star,
    };

    fetch(`/api/v1/products/${productId}/reviews`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(params),
    })
      .then(async (res) => {
        const data = await res.json();
        if (!res.ok) {
          this.showErrors(data.errors || ["Đã có lỗi xảy ra."]);
          throw new Error("Lỗi");
        }
        window.location.reload();
      })
      .catch((e) => {
        console.error(e);
      });
  }

  showErrors(messages) {
    this.errorsTarget.innerHTML = `
      <h2 class="font-bold mb-2">Vui lòng sửa các lỗi sau:</h2>
      <ul class="list-disc list-inside space-y-1">
        ${messages.map((msg) => `<li>${msg}</li>`).join("")}
      </ul>
    `;
    this.errorsTarget.classList.remove("hidden");
  }
}
