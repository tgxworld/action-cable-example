//= require subscribe-push-notifications

$(document).on('ready page:load', function() {
  register();

  if (localStorage.getItem('chatty-push-notifications') == 'subscribed') {
    $pushSubscriptionButton = $('#push-subscription');
    $pushSubscriptionButton.addClass('subscribed');
    $pushSubscriptionButton.text('Unsubscribe to Push Notifications');
  }

  $('#push-subscription').click(function() {
    var $this = $(this);

    if ($this.hasClass('subscribed')) {
      unsubscribe();
      $this.text('Subscribe to Push Notifications');
    } else {
      subscribe();
      $this.text('Unsubscribe to Push Notifications');
    }

    $this.toggleClass("subscribed");
  });
});
