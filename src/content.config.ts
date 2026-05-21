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

const settings = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/settings' }),
  schema: z.object({
    heroBadge: z.string().optional(),
    heroTitle: z.string().optional(),
    heroTitleAccent: z.string().optional(),
    heroSubtitle: z.string().optional(),
    heroSubtitle2: z.string().optional(),
    heroImage: z.string().optional(),
    heroSlides: z.array(z.object({ image: z.string(), alt: z.string().optional() })).optional(),
    recentWorkLabel: z.string().optional(),
    recentWorkNumber: z.string().optional(),
    feature1Label: z.string().optional(),
    feature2Label: z.string().optional(),
    feature3Label: z.string().optional(),
    servicesHeadline1: z.string().optional(),
    servicesHeadline2: z.string().optional(),
    processHeadline1: z.string().optional(),
    processHeadline2: z.string().optional(),
    ctaTitle2: z.string().optional(),
    ctaSubtitle: z.string().optional(),
  }),
});

const faqs = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/faqs' }),
  schema: z.object({
    question: z.string(),
    order: z.number().default(99),
    body: z.string().optional(),
  }),
});

export const collections = { works, settings, faqs };