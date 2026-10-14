// Seluruh string UI dwibahasa Indonesia dan Inggris.

/// Sumber tunggal teks yang tampil ke user. Widget tidak boleh punya
/// string const berisi teks, dan tidak boleh menulis teks langsung.
class AppStrings {
  const AppStrings._();

  static const String appName = 'Mailboxh';

  // Formatted fragments untuk plural dan interpolasi.
  static String greeting(String name) => 'Halo, $name';
  static String itemCount(int count) => '$count item';
  static String likeCount(int count) => '$count suka';


  /// Teks dalam Bahasa Indonesia.
  static const AppText id = AppText._id;

  /// Teks dalam Bahasa Inggris.
  static const AppText en = AppText._en;

  /// Pilih set teks sesuai kode bahasa.
  static AppText of(String languageCode) =>
      languageCode == 'en' ? en : id;
}

/// Kumpulan teks untuk satu bahasa.
class AppText {
  final bool isIndonesian;

// Umum
  final String appName;
  final String retry;
  final String cancel;
  final String save;
  final String delete;
  final String edit;
  final String confirm;
  final String loading;
  final String somethingWrong;
  final String emptyTitle;
  final String emptyMessage;
  final String errorTitle;
  final String errorMessage;
  final String searchHint;
  final String seeAll;

  // Navigasi
  final String navHome;
  final String navSearch;
  final String navWatchlist;
  final String navProfile;

  // Auth
  final String loginTitle;
  final String registerTitle;
  final String email;
  final String password;
  final String name;
  final String loginButton;
  final String registerButton;
  final String logout;
  final String noAccount;
  final String haveAccount;

  // Detail film
  final String addToWatchlist;
  final String markWatched;
  final String writeReview;
  final String editReview;
  final String likes;
  final String synopsis;

  // Watchlist dan watched
  final String watchlistEmpty;
  final String watchedEmpty;
  final String watchedAt;

  // Diary dan tags
  final String diaryTitle;
  final String diaryEmpty;
  final String filterByTag;
  final String tagsTitle;
  final String tagsEmpty;
  final String addTag;

  // Lists
  final String listsTitle;
  final String myLists;
  final String publicLists;
  final String listEmpty;
  final String createList;
  final String listTitleLabel;
  final String listDescriptionLabel;
  final String publicListLabel;
  final String addFilmToList;
  final String reorderList;

  // Favourites
  final String favouritesTitle;
  final String favouritesSlotLabel;
  final String detailTitle;
  final String reviewTitle;
  final String watchlistTitle;
  final String watchedTitle;
  final String listDetailTitle;
  final String listFormTitle;
  final String followingTitle;
  final String onboardingTitle;
  final String splashTitle;
  // Feed dan incoming
  final String feedTitle;
  final String feedEmpty;
  final String filterAll;
  final String filterWatched;
  final String filterRated;
  final String filterReviewed;
  final String filterLiked;
  final String filterListCreated;
  final String filterFollowed;
  final String incomingTitle;
  final String incomingEmpty;
  final String filterNewFollowers;
  final String filterLikedInList;
  final String activityWatched;
  final String activityRated;
  final String activityReviewed;
  final String activityLiked;
  final String activityListCreated;
  final String activityFollowed;
  final String exploreMembers;

  // Follow dan members
  final String follow;
  final String following;
  final String unfollow;
  final String followers;
  final String membersTitle;
  final String membersEmpty;
  final String membersSearchHint;

  // Form log
  final String logTitle;
  final String logNoteLabel;
  final String logRatingLabel;
  final String logReviewLabel;
  final String logTagsLabel;
  final String logAlreadyWatched;

  // Profile dan stats
  final String profileTitle;
  final String tabFilms;
  final String tabDiary;
  final String tabReviews;
  final String tabLists;
  final String tabTags;
  final String tabStats;
  final String statWatched;
  final String statWatchlist;
  final String statReviews;
  final String statLikes;
  final String statLists;
  final String statFollowers;
  final String statFollowing;

  // Settings
  final String settingsTitle;
  final String settingsLanguage;
  final String settingsAbout;
  final String settingsAttribution;
  final String settingsVersion;
  final String adminEnter;
  final String adminDashboard;
  final String adminMovies;
  final String adminGenres;
  final String adminUsers;
  final String adminReviews;
  final String adminLists;
  final String adminTags;
  final String adminAuditLogs;
  final String languageIndonesian;
  final String languageEnglish;

  static const AppText _id = AppText._(
    isIndonesian: true,
    appName: 'Mailboxh',
    retry: 'Coba lagi',
    cancel: 'Batal',
    save: 'Simpan',
    delete: 'Hapus',
    edit: 'Ubah',
    confirm: 'Konfirmasi',
    loading: 'Memuat',
    somethingWrong: 'Terjadi kesalahan',
    emptyTitle: 'Belum ada isi',
    emptyMessage: 'Data akan muncul di sini setelah tersedia.',
    errorTitle: 'Gagal memuat',
    errorMessage: 'Periksa koneksi lalu coba lagi.',
    searchHint: 'Cari film',
    seeAll: 'Lihat semua',
    navHome: 'Beranda',
    navSearch: 'Cari',
    navWatchlist: 'Watchlist',
    navProfile: 'Profil',
    loginTitle: 'Masuk',
    registerTitle: 'Daftar',
    email: 'Email',
    password: 'Kata sandi',
    name: 'Nama',
    loginButton: 'Masuk',
    registerButton: 'Daftar',
    logout: 'Keluar',
    noAccount: 'Belum punya akun',
    haveAccount: 'Sudah punya akun',
    addToWatchlist: 'Tambah ke watchlist',
    markWatched: 'Tandai sudah ditonton',
    writeReview: 'Tulis review',
    editReview: 'Ubah review',
    likes: 'Suka',
    synopsis: 'Sinopsis',
    watchlistEmpty: 'Watchlist masih kosong',
    watchedEmpty: 'Belum ada film yang ditonton',
    watchedAt: 'Ditonton',
    diaryTitle: 'Diary',
    diaryEmpty: 'Riwayat tontonan masih kosong',
    filterByTag: 'Saring tag',
    tagsTitle: 'Tag',
    tagsEmpty: 'Belum ada tag',
    addTag: 'Tambah tag',
    listsTitle: 'Lists',
    myLists: 'List saya',
    publicLists: 'List publik',
    listEmpty: 'Belum ada list',
    createList: 'Buat list',
    listTitleLabel: 'Judul list',
    listDescriptionLabel: 'Deskripsi',
    publicListLabel: 'List publik',
    addFilmToList: 'Tambah film ke list',
    reorderList: 'Ubah urutan',
    favouritesTitle: 'Four favourites',
    favouritesSlotLabel: 'Slot film favorit',
    detailTitle: 'Detail Film',
    reviewTitle: 'Form Review',
    watchlistTitle: 'Watchlist',
    watchedTitle: 'Watched',
    listDetailTitle: 'Isi List',
    listFormTitle: 'Form List',
    followingTitle: 'Following',
    onboardingTitle: 'Selamat datang',
    splashTitle: 'Mailboxh',
    feedTitle: 'Aktivitas',
    feedEmpty: 'Belum ada aktivitas',
    filterAll: 'Semua',
    filterWatched: 'Ditonton',
    filterRated: 'Dinilai',
    filterReviewed: 'Direview',
    filterLiked: 'Disukai',
    filterListCreated: 'List baru',
    filterFollowed: 'Mengikuti',
    incomingTitle: 'Aktivitas masuk',
    incomingEmpty: 'Belum ada aktivitas masuk',
    filterNewFollowers: 'Pengikut baru',
    filterLikedInList: 'Disukai di list',
    activityWatched: 'menonton',
    activityRated: 'memberi rating',
    activityReviewed: 'menulis review',
    activityLiked: 'menyukai',
    activityListCreated: 'membuat list',
    activityFollowed: 'mengikuti',
    exploreMembers: 'Jelajahi member',
    follow: 'Ikuti',
    following: 'Diikuti',
    unfollow: 'Berhenti mengikuti',
    followers: 'Pengikut',
    membersTitle: 'Member',
    membersEmpty: 'Member tidak ditemukan',
    membersSearchHint: 'Cari nama member',
    logTitle: 'Catat tontonan',
    logNoteLabel: 'Catatan',
    logRatingLabel: 'Rating',
    logReviewLabel: 'Review',
    logTagsLabel: 'Tag',
    logAlreadyWatched: 'Film ini sudah tercatat',
    profileTitle: 'Profil',
    tabFilms: 'Films',
    tabDiary: 'Diary',
    tabReviews: 'Reviews',
    tabLists: 'Lists',
    tabTags: 'Tags',
    tabStats: 'Stats',
    statWatched: 'Ditonton',
    statWatchlist: 'Watchlist',
    statReviews: 'Review',
    statLikes: 'Suka',
    statLists: 'Lists',
    statFollowers: 'Pengikut',
    statFollowing: 'Mengikuti',
    settingsTitle: 'Pengaturan',
    settingsLanguage: 'Bahasa',
    settingsAbout: 'Tentang aplikasi',
    settingsAttribution: 'Katalog film',
    settingsVersion: 'Versi aplikasi',
    adminEnter: 'Masuk ke Admin',
    adminDashboard: 'Dashboard',
    adminMovies: 'Film',
    adminGenres: 'Genre',
    adminUsers: 'User',
    adminReviews: 'Review',
    adminLists: 'List',
    adminTags: 'Tag',
    adminAuditLogs: 'Log Aktivitas',
    languageIndonesian: 'Indonesia',
    languageEnglish: 'Inggris',
  );

  static const AppText _en = AppText._(
    isIndonesian: false,
    appName: 'Mailboxh',
    retry: 'Try again',
    cancel: 'Cancel',
    save: 'Save',
    delete: 'Delete',
    edit: 'Edit',
    confirm: 'Confirm',
    loading: 'Loading',
    somethingWrong: 'Something went wrong',
    emptyTitle: 'Nothing here yet',
    emptyMessage: 'Data will appear once available.',
    errorTitle: 'Failed to load',
    errorMessage: 'Check your connection and try again.',
    searchHint: 'Search films',
    seeAll: 'See all',
    navHome: 'Home',
    navSearch: 'Search',
    navWatchlist: 'Watchlist',
    navProfile: 'Profile',
    loginTitle: 'Log in',
    registerTitle: 'Register',
    email: 'Email',
    password: 'Password',
    name: 'Name',
    loginButton: 'Log in',
    registerButton: 'Register',
    logout: 'Log out',
    noAccount: 'No account yet',
    haveAccount: 'Already have an account',
    addToWatchlist: 'Add to watchlist',
    markWatched: 'Mark as watched',
    writeReview: 'Write review',
    editReview: 'Edit review',
    likes: 'Likes',
    synopsis: 'Synopsis',
    watchlistEmpty: 'Watchlist is empty',
    watchedEmpty: 'No films watched yet',
    watchedAt: 'Watched',
    diaryTitle: 'Diary',
    diaryEmpty: 'Watch history is empty',
    filterByTag: 'Filter by tag',
    tagsTitle: 'Tags',
    tagsEmpty: 'No tags yet',
    addTag: 'Add tag',
    listsTitle: 'Lists',
    myLists: 'My lists',
    publicLists: 'Public lists',
    listEmpty: 'No lists yet',
    createList: 'Create list',
    listTitleLabel: 'List title',
    listDescriptionLabel: 'Description',
    publicListLabel: 'Public list',
    addFilmToList: 'Add film to list',
    reorderList: 'Reorder',
    favouritesTitle: 'Four favourites',
    favouritesSlotLabel: 'Favourite film slot',
    detailTitle: 'Film',
    reviewTitle: 'Review',
    watchlistTitle: 'Watchlist',
    watchedTitle: 'Watched',
    listDetailTitle: 'List',
    listFormTitle: 'List',
    followingTitle: 'Following',
    onboardingTitle: 'Welcome',
    splashTitle: 'Mailboxh',
    feedTitle: 'Activity',
    feedEmpty: 'No activity yet',
    filterAll: 'All',
    filterWatched: 'Watched',
    filterRated: 'Rated',
    filterReviewed: 'Reviewed',
    filterLiked: 'Liked',
    filterListCreated: 'New lists',
    filterFollowed: 'Follows',
    incomingTitle: 'Incoming activity',
    incomingEmpty: 'No incoming activity',
    filterNewFollowers: 'New followers',
    filterLikedInList: 'Liked in your lists',
    activityWatched: 'watched',
    activityRated: 'rated',
    activityReviewed: 'reviewed',
    activityLiked: 'liked',
    activityListCreated: 'created a list',
    activityFollowed: 'followed',
    exploreMembers: 'Explore members',
    follow: 'Follow',
    following: 'Following',
    unfollow: 'Unfollow',
    followers: 'Followers',
    membersTitle: 'Members',
    membersEmpty: 'No members found',
    membersSearchHint: 'Search member name',
    logTitle: 'Log a film',
    logNoteLabel: 'Note',
    logRatingLabel: 'Rating',
    logReviewLabel: 'Review',
    logTagsLabel: 'Tags',
    logAlreadyWatched: 'This film is already logged',
    profileTitle: 'Profile',
    tabFilms: 'Films',
    tabDiary: 'Diary',
    tabReviews: 'Reviews',
    tabLists: 'Lists',
    tabTags: 'Tags',
    tabStats: 'Stats',
    statWatched: 'Watched',
    statWatchlist: 'Watchlist',
    statReviews: 'Reviews',
    statLikes: 'Likes',
    statLists: 'Lists',
    statFollowers: 'Followers',
    statFollowing: 'Following',
    settingsTitle: 'Settings',
    settingsLanguage: 'Language',
    settingsAbout: 'About',
    settingsAttribution: 'Movie catalogue',
    settingsVersion: 'App version',
    adminEnter: 'Open Admin',
    adminDashboard: 'Dashboard',
    adminMovies: 'Films',
    adminGenres: 'Genres',
    adminUsers: 'Users',
    adminReviews: 'Reviews',
    adminLists: 'Lists',
    adminTags: 'Tags',
    adminAuditLogs: 'Activity Logs',
    languageIndonesian: 'Indonesian',
    languageEnglish: 'English',
  );

  /// Konstruktor tunggal yang dipakai oleh dua konstanta bahasa.
  const AppText._({
    required this.isIndonesian,
    required this.appName,
    required this.retry,
    required this.cancel,
    required this.save,
    required this.delete,
    required this.edit,
    required this.confirm,
    required this.loading,
    required this.somethingWrong,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.errorTitle,
    required this.errorMessage,
    required this.searchHint,
    required this.seeAll,
    required this.navHome,
    required this.navSearch,
    required this.navWatchlist,
    required this.navProfile,
    required this.loginTitle,
    required this.registerTitle,
    required this.email,
    required this.password,
    required this.name,
    required this.loginButton,
    required this.registerButton,
    required this.logout,
    required this.noAccount,
    required this.haveAccount,
    required this.addToWatchlist,
    required this.markWatched,
    required this.writeReview,
    required this.editReview,
    required this.likes,
    required this.synopsis,
    required this.watchlistEmpty,
    required this.watchedEmpty,
    required this.watchedAt,
    required this.diaryTitle,
    required this.diaryEmpty,
    required this.filterByTag,
    required this.tagsTitle,
    required this.tagsEmpty,
    required this.addTag,
    required this.listsTitle,
    required this.myLists,
    required this.publicLists,
    required this.listEmpty,
    required this.createList,
    required this.listTitleLabel,
    required this.listDescriptionLabel,
    required this.publicListLabel,
    required this.addFilmToList,
    required this.reorderList,
    required this.favouritesTitle,
    required this.favouritesSlotLabel,
    required this.detailTitle,
    required this.reviewTitle,
    required this.watchlistTitle,
    required this.watchedTitle,
    required this.listDetailTitle,
    required this.listFormTitle,
    required this.followingTitle,
    required this.onboardingTitle,
    required this.splashTitle,    required this.feedTitle,
    required this.feedEmpty,
    required this.filterAll,
    required this.filterWatched,
    required this.filterRated,
    required this.filterReviewed,
    required this.filterLiked,
    required this.filterListCreated,
    required this.filterFollowed,
    required this.incomingTitle,
    required this.incomingEmpty,
    required this.filterNewFollowers,
    required this.filterLikedInList,
    required this.activityWatched,
    required this.activityRated,
    required this.activityReviewed,
    required this.activityLiked,
    required this.activityListCreated,
    required this.activityFollowed,
    required this.exploreMembers,
    required this.follow,
    required this.following,
    required this.unfollow,
    required this.followers,
    required this.membersTitle,
    required this.membersEmpty,
    required this.membersSearchHint,
    required this.logTitle,
    required this.logNoteLabel,
    required this.logRatingLabel,
    required this.logReviewLabel,
    required this.logTagsLabel,
    required this.logAlreadyWatched,
    required this.profileTitle,
    required this.tabFilms,
    required this.tabDiary,
    required this.tabReviews,
    required this.tabLists,
    required this.tabTags,
    required this.tabStats,
    required this.statWatched,
    required this.statWatchlist,
    required this.statReviews,
    required this.statLikes,
    required this.statLists,
    required this.statFollowers,
    required this.statFollowing,
    required this.settingsTitle,
    required this.settingsLanguage,
    required this.settingsAbout,
    required this.settingsAttribution,
    required this.settingsVersion,
    required this.adminEnter,
    required this.adminDashboard,
    required this.adminMovies,
    required this.adminGenres,
    required this.adminUsers,
    required this.adminReviews,
    required this.adminLists,
    required this.adminTags,
    required this.adminAuditLogs,
    required this.languageIndonesian,
    required this.languageEnglish,
  });
}