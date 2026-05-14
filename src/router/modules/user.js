export default [{
  path: '',
  component: () => import('@/layouts/main/Main.vue'),
  children: [
    {
      path: '/hub',
      name: 'hub',
      component: () => import('@/views/user/Hub.vue'),
      meta: {
        requiresAuth: true,
        roles: ['[ICE] Applicant', '[ICE] Member']
      },
    },
    {
      path: '/applications',
      name: 'Applications',
      component: () => import('@/views/user/Applications.vue'),
      meta: {
        requiresAuth: true,
        roles: ['[ICE] Member', '[ICE] Applicant']
      },
    },

    {
      path: '/applications/view/:applicationID',
      name: 'Application',
      component: () => import('@/views/user/Application.vue'),
      meta: {
        requiresAuth: true,
        roles: ['[ICE] Applicant', '[ICE] Member']
      },
      props: true
    },
    {
      path: '/17th/apply',
      name: '17thApply',
      component: () => import('@/views/17th/Apply.vue'),
      meta: {
        requiresAuth: true,
        roles: ['[ICE] Applicant', '[ICE] Member']
      },
    },
    {
      path: '/iceberg/apply',
      name: 'IcebergApply',
      component: () => import('@/views/Iceberg/Apply.vue'),
      meta: {
        requiresAuth: true,
        roles: ['[ICE] Applicant']
      },
    },
    {
      path: '/cgs/apply',
      name: 'CGSApply',
      component: () => import('@/views/cgs/Apply.vue'),
      meta: {
        requiresAuth: true,
        roles: ['[ICE] Applicant', '[ICE] Member']
      },
    },
    {
      path: '/settings',
      name: 'Settings',
      component: () => import('@/views/user/Settings.vue'),
      meta: {
        requiresAuth: true,
        roles: ['[ICE] Applicant', '[ICE] Member']
      },
    },
    {
      path: '/iceberg/disciplinary-action',
      name: 'SubmitDisciplinaryAction',
      component: () => import('@/views/Iceberg/Disciplinary-Action.vue'),
      meta: {
        requiresAuth: true,
        roles: ['[ICE] Member']
      },
      props: true
    },
    {
      path: '/channels/:channelID',
      name: 'ViewChannel',
      component: () => import('@/views/channel/ViewChannel.vue'),
      meta: {
        requiresAuth: true,
        roles: ['[ICE] Member']
      },
      props: true
    },
    {
      path: '/channels/:channelID/events/:eventID',
      name: 'ViewEvent',
      component: () => import('@/views/channel/calendar/ViewEvent.vue'),
      meta: {
        requiresAuth: true,
        roles: ['[ICE] Member']
      },
      props: true
    },
    {
      path: '/channels/:channelID/documents/:documentID',
      name: 'ViewDocument',
      component: () => import('@/views/channel/documents/ViewDocument.vue'),
      meta: {
        requiresAuth: true,
        roles: ['[ICE] Member']
      },
      props: true
    },
    {
      path: '/channels/:channelID/topics/:topicID',
      name: 'ViewTopics',
      component: () => import('@/views/channel/forums/ViewTopic.vue'),
      meta: {
        requiresAuth: true,
        roles: ['[ICE] Member']
      },
      props: true
    },
    // {
    //   path: '/profile/:userID',
    //   name: 'Profile',
    //   component: () => import('@/views/user/Profile'),
    //   meta: {
    //     requiresAuth: true,
    //     roles: ['[ICE] Member']
    //   },
    //   props: true
    // },
  ]
}]
