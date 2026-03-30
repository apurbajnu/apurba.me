import { getPermalink, getBlogPermalink, getAsset } from './utils/permalinks';

export const headerData = {
  links: [
    {
      text: 'Home',
      href: getPermalink('/'),
    },
    {
      text: 'Skills',
      href: getPermalink('/#skills'),
    },
    {
      text: 'Projects',
      href: getPermalink('/#projects'),
    },
    {
      text: 'Thoughts',
      href: getPermalink('/#thoughts'),
    },
  ],
  actions: [{ text: 'Contact Me', href: 'mailto:apurba@apurba.me' }],
};

export const footerData = {
  links: [],
  secondaryLinks: [
    { text: 'Terms', href: getPermalink('/terms') },
    { text: 'Privacy Policy', href: getPermalink('/privacy') },
  ],
  socialLinks: [
    { ariaLabel: 'Github', icon: 'tabler:brand-github', href: 'https://github.com/apurbajnu' },
    { ariaLabel: 'X', icon: 'tabler:brand-x', href: '#' },
  ],
  footNote: `
    © ${new Date().getFullYear()} Apurba Podder · All rights reserved.
  `,
};
