-- complain if script is sourced in psql, rather than via CREATE EXTENSION
-- This line ensures that the file won ’ t be loaded into the database directly,
-- but only via CREATE EXTENSION
\echo Use "CREATE EXTENSION base36" to load this file. \quit
CREATE FUNCTION base36_encode(digits int)
RETURNS character varying
LANGUAGE plpgsql IMMUTABLE STRICT
  AS $$
    DECLARE
      chars char[];
      ret varchar;
      val int;
    BEGIN
      IF digits = 0
        THEN RETURN('0');
      END IF;
      chars := ARRAY[
                '0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f','g','h',
                'i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'
              ];

      val := digits;
      ret := '';

    WHILE val != 0 LOOP
      ret := chars[(val % 36)+1] || ret;
      val := val / 36;
    END LOOP;

    RETURN(ret);
    END;
  $$;

-- The simple plpgsql function allows us to encode any integer into its base36 representation.If we copied these two files into postgres SHAREDIR / extension directory,
-- then we could start using the extension with CREATE EXTENSION.But we won ’ t bother users with figuring out
-- where
--     to put these files
--     and how to copy them manually – that ’ s what Makefiles are made for.
-- Every PostgreSQL installation
-- from
--     9.1 onwards provides a build infrastructure for extensions called PGXS,
--     allowing extensions to be easily built against an already - installed server.Most of the environment variables needed to build an extension are setup in pg_config
--     and can simply be reused.
