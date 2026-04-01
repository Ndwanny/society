-- ============================================================
-- Society260 Seed Data
-- Run AFTER schema.sql. Creates sample events, blog posts,
-- and courses. (Users come from real sign-ups via auth.)
-- ============================================================

-- ─── EVENTS ──────────────────────────────────────────────────
insert into public.events (title, description, date, location, is_virtual, attendees, category, is_past) values
  ('260 Poetry Chapter 3',
   'An intimate evening of spoken word, poetry, and raw expression. Join us for our third chapter where voices unite.',
   now() + interval '14 days', 'Lusaka Arts Centre, Lusaka', false, 47, 'poetry', false),

  ('Club260 Virtual Hangout',
   'Monthly community check-in. Share how you''ve been, connect with members, and enjoy guided mindfulness.',
   now() + interval '7 days', 'Online — Zoom', true, 89, 'club260', false),

  ('Sauti Society x Society260',
   'A music and mental health collaboration featuring original compositions and panel discussions.',
   now() + interval '30 days', 'Alliance Française, Lusaka', false, 120, 'music', false),

  ('Art Therapy Workshop',
   'Guided creative session exploring emotions through painting and collage. All skill levels welcome.',
   now() - interval '10 days', 'Woodlands, Lusaka', false, 34, 'workshop', true),

  ('Code260 Launch Event',
   'Unveiling of our children''s mental wellness comic series. Meet the artists and grab your first issue.',
   now() - interval '30 days', 'Online', true, 210, 'code260', true);

-- ─── BLOG POSTS ──────────────────────────────────────────────
insert into public.blog_posts (title, excerpt, content, cover_image, tags, read_time, views, category, is_published) values
  ('Breaking the Silence: Mental Health in Zambia',
   'Exploring the cultural barriers around mental health conversations and how communities are pushing back.',
   'Full article content goes here...',
   null,
   array['mental health', 'zambia', 'awareness'], 6, 1240, 'mentalHealth', true),

  ('How Art Saved Me: A Personal Journey',
   'One member shares how creative expression became her lifeline during her darkest moments.',
   'Full article content goes here...',
   null,
   array['art therapy', 'personal story', 'healing'], 4, 890, 'mentalHealth', true),

  ('Code260: Comics as a Mental Health Tool for Children',
   'Why we chose comics to talk about big emotions with young people — and what the research says.',
   'Full article content goes here...',
   null,
   array['code260', 'children', 'comics'], 5, 654, 'code260', true),

  ('Club260 October Wrap-Up',
   'A look back at our most-engaged month yet — highlights, member stories, and what''s coming next.',
   'Full article content goes here...',
   null,
   array['club260', 'community', 'events'], 3, 432, 'community', true);

-- ─── COURSES ─────────────────────────────────────────────────
insert into public.courses (title, description, instructor, lessons, total_duration, rating, enrolled, level, is_premium, topics) values
  ('Understanding Your Mind',
   'A beginner''s guide to mental wellness — learn to identify emotions, build coping strategies, and set healthy boundaries.',
   'Dr. Amara Banda', 12, '4h 30m', 4.8, 234, 'beginner', false,
   array['emotions', 'coping', 'boundaries', 'self-care']),

  ('Resilience Building Masterclass',
   'Deep dive into psychological resilience. Evidence-based techniques for bouncing back stronger from adversity.',
   'Naledi Moyo', 18, '6h 15m', 4.9, 187, 'intermediate', true,
   array['resilience', 'trauma', 'growth', 'mindfulness']),

  ('Creative Healing: Art Therapy Fundamentals',
   'Use art as a therapeutic tool. No artistic skill needed — just openness to expression.',
   'Chanda Lumina', 8, '3h 00m', 4.7, 156, 'beginner', false,
   array['art therapy', 'creativity', 'expression', 'healing']),

  ('Mindful Parenting in Modern Africa',
   'Navigate the unique challenges of raising emotionally healthy children in contemporary African contexts.',
   'Dr. James Phiri', 15, '5h 45m', 4.6, 98, 'intermediate', true,
   array['parenting', 'children', 'mindfulness', 'family']);
