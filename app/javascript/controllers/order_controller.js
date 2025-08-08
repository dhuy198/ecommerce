import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  make() {
    const userId = this.element.dataset.userId;
    const params = {
      user_id: userId,
    };
    const options = {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(params),
    };
    fetch("/api/v1/orders", options)
      .then((res) => {
        return res.json().then((data) => {
          if (!res.ok) {
            throw data;
          }
          return data;
        });
      })
      .then((data) => {
        window.location.href = "/thanks";
      })
      .catch((e) => {
        if (e.messages) {
          e.messages.forEach((msg) => showAlert(msg));
        } else if (e.error) {
          showAlert(e.error);
        } else {
          showAlert("Đã xảy ra lỗi không xác định.");
        }
      });
  }
}
