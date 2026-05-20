import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const works = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/works' }),
  schema: z.object({
    title: z.string(),
    location: z.string(),
    area: z.number().optional(),
    category: z.enum(['주거', '카페', '상업공간', '사무공간', '기타']),
    date: z.date(),
    thumbnail: z.string(),
    gallery: z.array(z.string()).optional(),
    specs: z.string().optional(),
    duration: z.string().default('1일 완공'),
    featured: z.boolean().default(false),
  }),
});

const faqs = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/faqs' }),
  schema: z.object({
    question: z.string(),
    order: z.number().default(99),
  }),
});

const settings = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/settings' }),
  schema: z.object({
    heroBadge: z.string().default('CONCRETE POLISHING STUDIO'),
    heroTitle: z.string().default('콘크리트의'),
    heroTitleAccent: z.string().default('새로운 기준.'),
    heroSubtitle: z.string().default('1일 완공. 원하는 색상, 원하는 규사.'),
    heroSubtitle2: z.string().default('시공이 아닌 작품으로 마감합니다.'),
    heroImage: z.string().optional(),
    heroSlides: z.array(z.object({
      image: z.string(),
      alt: z.string().optional(),
    })).default([]),
    recentWorkLabel: z.string().default('FEATURED WORK'),
    recentWorkNumber: z.string().default('No. 001'),
  }),
});

export const collections = { works, faqs, settings };