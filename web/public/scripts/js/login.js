$(document).ready(function () {
  sessionStorage.ktt = 0
  $('#btnregister').click(function () {
    window.location.href = '/register'
  })
  $('#btnlogin').click(function () {
    window.location.href = '/auth/google/redirect'
  })

  //     const signUpButton = document.getElementById('signUp');
  // const signInButton = document.getElementById('signIn');
  // const container = document.getElementById('container');

  // signUpButton.addEventListener('click', () => {
  // 	container.classList.add("right-panel-active");
  // });

  // signInButton.addEventListener('click', () => {
  // 	container.classList.remove("right-panel-active");
  // });
})
