import 'package:get/get.dart';
import 'package:zeffaf/models/newMessage.modal.dart';
import 'package:zeffaf/pages/add.story/view.dart';
import 'package:zeffaf/pages/add_agent/bindings/add_agent_binding.dart';
import 'package:zeffaf/pages/add_agent/views/add_agent_view.dart';
import 'package:zeffaf/pages/agent/bindings/agent_binding.dart';
import 'package:zeffaf/pages/agent/views/agent_view.dart';
import 'package:zeffaf/pages/app_messages/AppMessage.controller.dart';
import 'package:zeffaf/pages/app_messages/AppMessage.view.dart';
import 'package:zeffaf/pages/auto.search.setting/auto.search.setting.controller.dart';
import 'package:zeffaf/pages/auto.search.setting/auto.search.setting.view.dart';
import 'package:zeffaf/pages/auto.search/auto.search.controller.dart';
import 'package:zeffaf/pages/auto.search/view.dart';
import 'package:zeffaf/pages/chat.details/chat.details.controller.dart';
import 'package:zeffaf/pages/chat.details/view.dart';
import 'package:zeffaf/pages/chat.list/chat.list.controller.dart';
import 'package:zeffaf/pages/chat.list/view.dart';
import 'package:zeffaf/pages/city.list/city.list.controller.dart';
import 'package:zeffaf/pages/city.list/view.dart';
import 'package:zeffaf/pages/confirm.new.password/cnp.controller.dart';
import 'package:zeffaf/pages/confirm.new.password/view.dart';
import 'package:zeffaf/pages/contact_us/contact_us_listing/contact_us_bindings.dart';
import 'package:zeffaf/pages/contact_us/contact_us_listing/contact_us_view.dart';
import 'package:zeffaf/pages/contact_us/send_contact_us_message/send_contact_us_message_bindings.dart';
import 'package:zeffaf/pages/contact_us/send_contact_us_message/send_contact_us_message_view.dart';
import 'package:zeffaf/pages/country.code/countrycode.controller.dart';
import 'package:zeffaf/pages/country.code/view.dart';
import 'package:zeffaf/pages/edit_account/binding.dart';
import 'package:zeffaf/pages/edit_account/view.dart';
import 'package:zeffaf/pages/favorites/favorites.controller.dart';
import 'package:zeffaf/pages/friends/friends.controller.dart';
import 'package:zeffaf/pages/friends/friends.view.dart';
import 'package:zeffaf/pages/how_to_use/howToUse.controller.dart';
import 'package:zeffaf/pages/how_to_use/howToUse.view.dart';
import 'package:zeffaf/pages/list.select.multi.item/list.select.multi.item.controller.dart';
import 'package:zeffaf/pages/list.select.multi.item/view.dart';
import 'package:zeffaf/pages/login/bindings.dart';
import 'package:zeffaf/pages/login/view.dart';
import 'package:zeffaf/pages/message.details/message.details.controller.dart';
import 'package:zeffaf/pages/message.details/message.details.view.dart';
import 'package:zeffaf/pages/more/message_from_zefaaf_view.dart';
import 'package:zeffaf/pages/more/more.controller.dart';
import 'package:zeffaf/pages/myAccount/myAccount.controller.dart';
import 'package:zeffaf/pages/new.message/newMessage.controller.dart';
import 'package:zeffaf/pages/new.message/newMessage.view.dart';
import 'package:zeffaf/pages/notifications/notifications.controller.dart';
import 'package:zeffaf/pages/notifications/notifications.view.dart';
import 'package:zeffaf/pages/onboarding/onboarding.controller.dart';
import 'package:zeffaf/pages/onboarding/view.dart';
import 'package:zeffaf/pages/our_message/ourMessage.controller.dart';
import 'package:zeffaf/pages/our_message/ourMessage.view.dart';
import 'package:zeffaf/pages/packages/packages.controller.dart';
import 'package:zeffaf/pages/packages/paypal/paypal.controller.dart';
import 'package:zeffaf/pages/packages/paypal/paypal.payment.dart';
import 'package:zeffaf/pages/packages/view.dart';
import 'package:zeffaf/pages/payment/payment.controller.dart';
import 'package:zeffaf/pages/payment/payment.view.dart';
import 'package:zeffaf/pages/post_details/postDetails.controller.dart';
import 'package:zeffaf/pages/posts/posts.controller.dart';
import 'package:zeffaf/pages/posts/posts.view.dart';
import 'package:zeffaf/pages/privacy/privacy.controller.dart';
import 'package:zeffaf/pages/privacy/privacy.view.dart';
import 'package:zeffaf/pages/purchase.processing/view.dart';
import 'package:zeffaf/pages/purchase.success/view.dart';
import 'package:zeffaf/pages/register/register.pages/about.you/about.you.controller.dart';
import 'package:zeffaf/pages/register/register.pages/account.info/account.information.controller.dart';
import 'package:zeffaf/pages/register/register.pages/ask.about.his.life/ask.about.his.life.controller.dart';
import 'package:zeffaf/pages/register/register.pages/social.status/social.status.controller.dart';
import 'package:zeffaf/pages/register/view.dart';
import 'package:zeffaf/pages/register_landing/view.dart';
import 'package:zeffaf/pages/request.change.password/request.change.password.controller.dart';
import 'package:zeffaf/pages/request.change.password/view.dart';
import 'package:zeffaf/pages/search_filter/search.filter.binding.dart';
import 'package:zeffaf/pages/search_filter/serachFilter.view.dart';
import 'package:zeffaf/pages/search_result/search.result.binding.dart';
import 'package:zeffaf/pages/search_result/searchResults.view.dart';
import 'package:zeffaf/pages/settings/settings.controller.dart';
import 'package:zeffaf/pages/settings/settings.view.dart';
import 'package:zeffaf/pages/splash_page.dart';
import 'package:zeffaf/pages/success.stories/success.stories.controller.dart';
import 'package:zeffaf/pages/success.stories/view.dart';
import 'package:zeffaf/pages/sunna_marrage/suna_posts.controller.dart';
import 'package:zeffaf/pages/sunna_marrage/suna_posts.view.dart';
import 'package:zeffaf/pages/terms.and.conditions/terms.and.conditions.controller.dart';
import 'package:zeffaf/pages/terms.and.conditions/terms.and.conditions.view.dart';
import 'package:zeffaf/pages/user_details/user_details.controller.dart';
import 'package:zeffaf/pages/user_details/user_details.view.dart';
import 'package:zeffaf/services/fAuth.dart';
import 'package:zeffaf/services/notification.service.dart';

import 'pages/forget.password/forget.password.controller.dart';
import 'pages/home/home.controller.dart';
import 'pages/home/home.view.dart';
import 'pages/register/register.controller.dart';
import 'pages/register_landing/register.landing.controller.dart';
import 'pages/sms.verification/sms.verification.controller.dart';
import 'pages/sms.verification/view.dart';
import 'widgets/bottomTabsHome.dart';

routes() => [
      GetPage(
        name: "/",
        page: () => const SplashPage(),
        binding: PagesBind(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/on_boarding",
        page: () => OnBoardingView(),
        binding: PagesBind(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/BottomTabsHome",
        page: () => const BottomTabsHome(),
        binding: BottomTabsBinding(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/EditAccount",
        page: () => const EditAccountView(),
        binding: EditAccountBinding(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/SearchFilter",
        page: () => SearchFilter(),
        binding: SearchFilterBinding(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/MessageFromZefaafView",
        page: () => const MessageFromZefaafView(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/Notifications",
        page: () => Notifications(),
        binding: PagesBind(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/OurMessage",
        page: () => OurMessage(),
        binding: PagesBind(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/OnBoarding",
        page: () => OnBoardingView(),
        binding: PagesBind(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/Home",
        page: () => const Home(),
        binding: PagesBind(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/Login",
        page: () => const LoginView(),
        binding: LoginBinding(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/register",
        page: () => RegisterView(),
        binding: PagesBind(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/confirm_new_pass",
        page: () => ConfirmNewPasswordView(),
        binding: PagesBind(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/RegisterLandingView",
        page: () => RegisterLandingView(),
        binding: PagesBind(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/ListOfItemsView",
        page: () => ListOfItemsView(),
        binding: PagesBind(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/PaypalPayment",
        page: () => PaypalPayment(),
        binding: PagesBind(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/CountryCodeView",
        page: () => CountryCode(),
        binding: PagesBind(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/Agent",
        page: () => AgentView(),
        binding: AgentBinding(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/chatList",
        page: () => ChatList(),
        binding: PagesBind(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/payment_view",
        page: () => PaymentView(),
        binding: PagesBind(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/success_stories",
        page: () => SuccessStories(),
        binding: PagesBind(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/auto_search",
        page: () => AutoSearch(),
        binding: PagesBind(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/auto_search_setting",
        page: () => AutoSearchSettingView(),
        binding: PagesBind(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/CityListView",
        page: () => CityListView(),
        binding: PagesBind(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/request_change_password",
        page: () => const RequestChangePasswordView(),
        binding: PagesBind(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/add_story",
        page: () => AddStory(),
        binding: PagesBind(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/AppMessageView",
        page: () => const AppMessageView(),
        binding: PagesBind(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/sms_verification",
        page: () => SMSVerification(),
        binding: PagesBind(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/Settings",
        page: () => Settings(),
        binding: PagesBind(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/Posts",
        page: () => Posts(),
        binding: PagesBind(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/PurchaseSuccess",
        page: () => const PurchaseSuccess(),
        binding: PurchaseSuccessBinding(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/PurchaseProcessing",
        page: () => const PurchaseProcessing(),
        binding: PurchaseProcessingBinding(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/packages",
        page: () => Packages(),
        binding: PagesBind(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/chat_details",
        page: () => ChatDetails(),
        binding: PagesBind(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/terms_and_conditions",
        page: () => TermsAndConditions(),
        binding: PagesBind(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/message_details",
        page: () => MessageDetails(
          newMessagesModal: NewMessagesModal(),
        ),
        binding: PagesBind(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/SearchResult",
        page: () => SearchResult(),
        binding: SearchResultBinding(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/ContactUS",
        page: () => const ContactUSView(),
        binding: ContactUsBinding(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/SendContactUSMessage",
        page: () => const SendContactUSMessageView(),
        binding: SendContactUSMessageBinding(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/Privacy",
        page: () => Privacy(),
        binding: PagesBind(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/HowToUse",
        page: () => HowToUse(),
        binding: PagesBind(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/Friends",
        page: () => Friends(),
        binding: PagesBind(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/AddAgent",
        page: () => AddAgentView(),
        binding: AddAgentBinding(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/NewMessage",
        page: () => NewMessage(),
        binding: PagesBind(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/SunnaMarriage",
        page: () => SunnaMarriage(),
        binding: PagesBind(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/UserDetails",
        page: () => UserDetails(isFavourite: false),
        binding: PagesBind(),
        transition: Transition.fade,
      ),
    ];

class PagesBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserDetailsController>(() => UserDetailsController());
    Get.lazyPut<SunnaMarriageController>(() => SunnaMarriageController());
    Get.lazyPut<AppMessageController>(() => AppMessageController());
    Get.lazyPut<RegisterController>(() => RegisterController());
    Get.lazyPut<PostDetailsController>(() => PostDetailsController());
    Get.lazyPut<PrivacyController>(() => PrivacyController());
    Get.lazyPut<SuccessStoriesController>(() => SuccessStoriesController());
    Get.lazyPut<HowToUseController>(() => HowToUseController());
    Get.lazyPut<CityListController>(() => CityListController());
    Get.lazyPut<CountryCodeController>(() => CountryCodeController());
    Get.lazyPut<RegisterLandingController>(() => RegisterLandingController());
    Get.lazyPut<PurchaseProcessingController>(
        () => PurchaseProcessingController());
    Get.lazyPut<PaypalController>(() => PaypalController());
    Get.lazyPut<OnBoardingController>(() => OnBoardingController());
    Get.lazyPut<SMSVerificationController>(() => SMSVerificationController());
    Get.lazyPut<ForgetPasswordController>(() => ForgetPasswordController());
    Get.lazyPut<AccountInformationController>(
        () => AccountInformationController());
    Get.lazyPut<SocialStatusController>(() => SocialStatusController());
    Get.lazyPut<AskAboutHisLifeController>(() => AskAboutHisLifeController());
    Get.lazyPut<AboutYouController>(() => AboutYouController());
    Get.lazyPut<AutoSearchController>(() => AutoSearchController());
    Get.lazyPut<PaymentController>(() => PaymentController());
    Get.lazyPut<MoreController>(() => MoreController());
    Get.lazyPut<ConfirmNewPasswordController>(
        () => ConfirmNewPasswordController());
    Get.lazyPut<ListSelectMultiItemController>(
        () => ListSelectMultiItemController());
    Get.lazyPut<PackagesController>(() => PackagesController());
    Get.lazyPut<FAuthController>(() => FAuthController());
    Get.lazyPut<MessageDetailsController>(() => MessageDetailsController());
    Get.lazyPut<AutoSearchSettingController>(
        () => AutoSearchSettingController());
    Get.lazyPut<RequestChangePasswordController>(
        () => RequestChangePasswordController());
    Get.lazyPut<SettingsController>(() => SettingsController());
    Get.lazyPut<FavoritesController>(() => FavoritesController());
    Get.lazyPut<PostsController>(() => PostsController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<NewMessageController>(() => NewMessageController());
    Get.lazyPut<FriendsController>(() => FriendsController());
    Get.lazyPut<ChatListController>(() => ChatListController());
    Get.lazyPut<ChatDetailsController>(() => ChatDetailsController());
    Get.lazyPut<TermsAndConditionsController>(
        () => TermsAndConditionsController());
    Get.lazyPut<MyAccountController>(() => MyAccountController());
    Get.lazyPut<OurMessageController>(() => OurMessageController());
    Get.lazyPut<NotificationsController>(() => NotificationsController());
    Get.lazyPut<NotificationsService>(() => NotificationsService());
  }
}
